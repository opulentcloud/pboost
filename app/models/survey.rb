class Survey < ContactList
	acts_as_reportable

	#====== ASSOCIATIONS =======
	has_many :survey_attachments, :as => :attachable, :dependent => :destroy
	accepts_nested_attributes_for :survey_attachments
	
	#====== VALIDATIONS =======

	#====== EVENTS ======

	#====== INSTANCE METHODS =======	
	#determine if we need to map the fields.
	def rows(x = 10)
		i = ListImporter.new(self.survey_attachments.last.file_name, 'survey', self.id)
		i.rows(x)
	end

	def need_mapping
		return false unless self.upload_list == true
		return false if self.mapped_fields.blank? == false
		return true if self.survey_attachments.nil?
		 i = ListImporter.new(self.survey_attachments.last.file_name, 'survey', self.id)
		 i.need_mapping
	end
	
	def contact_list_id
		self.id
	end
	
	def filename(format)
		"survey_#{self.id}.#{format}"
	end

	def populate
		delete_file

		self.populated = false
		self.repopulate = false
		self.save!

		if !self.upload_list == true

		sql1_header = <<-eot
			INSERT INTO contact_list_voters
			SELECT 
				nextval('contact_list_voters_id_seq') AS id, 
				 "contact_lists"."id", "voters"."id", now() AS created_at, now() AS updated_at 
			FROM 
				"contact_lists", "constituents", "voters", "addresses"
			WHERE
				("contact_lists"."id" = #{self.id})
			AND
				("constituents"."political_campaign_id" = "contact_lists"."political_campaign_id") 
			AND
				("voters"."id" = "constituents"."voter_id")
			AND
				("addresses"."id" = "voters"."address_id")
		eot
			
			sql = ''

			if self.gis_region
				sql += <<-eot
					AND 
						("addresses"."geom" && '#{self.gis_region.geom2.as_hex_ewkb}' ) 
				 AND 
						ST_contains('#{self.gis_region.geom2.as_hex_ewkb}', "addresses"."geom"::geometry)
				eot
			elsif self.precinct_filter
				sql += <<-eot
					AND ("addresses"."precinct_code" = '#{self.precinct_filter.string_val}') 
				eot
			end

			if self.municipal_district_filter
				sql += <<-eot
					AND ("addresses"."mcomm_dist_code" = '#{self.municipal_district_filter.string_val}') 
				eot
			end

			if self.council_district_filter
				sql += <<-eot
					AND ("addresses"."comm_dist_code" = '#{self.council_district_filter.string_val}') 
				eot
			end

			sql += <<-eot
				AND
					("constituents"."voter_id" = (SELECT v.id FROM voters v WHERE v.address_id = addresses.id 
			eot

			if self.age_filter
				sql += <<-eot
					AND
						(v.age BETWEEN #{self.age_filter.int_val} AND #{self.age_filter.max_int_val})
				eot
			end

			if self.sex_filter
				sql += <<-eot
					AND
						(v.sex = '#{self.sex_filter.string_val}')
				eot
			end

			if self.party_filters.size > 0
				@in = self.party_filters.map { |f| "'"+Party.find(f.int_val).code+"'" }.join(',')
				sql += <<-eot
					AND
						(v.party IN (#{@in}))
				eot
			end

			if self.voting_history_filters.size > 0
				sql_temp = case self.voting_history_type_filter.string_val
					when 'Any' then build_any_voting_history_query
					when 'All' then build_all_voting_history_query
					when 'At Least' then build_at_least_voting_history_query
					when 'Exactly' then build_exactly_voting_history_query
					when 'No More Than' then build_no_more_than_voting_history_query
				end
				sql += sql_temp.gsub("\"voters\".\"id\"", "v.id")
			end

		sql += <<-eot
		AND (v.phone != \'\') LIMIT 1))
		eot

		sql2_header = <<-eot
			INSERT INTO contact_list_addresses
			SELECT
				nextval('contact_list_addresses_id_seq') AS id, 
				r.*, now() AS created_at, now() AS updated_at
			FROM
			(SELECT 
				DISTINCT "contact_list_voters"."contact_list_id", "voters"."address_id" 
			FROM 
				"contact_list_voters", "voters"
			WHERE
				("contact_list_voters"."contact_list_id" = #{self.id})
			AND
				"voters"."id" = "contact_list_voters"."voter_id") AS r;		
			eot
		
		sql1 = sql1_header + sql + '; ' + sql2_header
		logger.debug(sql1)
		sql_result = ActiveRecord::Base.connection.execute(sql1)

		end #end if !self.upload_list == true
#debugger
		if self.voters.count > 0 && !self.upload_list == true
			#build list of surveys from voters.
			sql = <<-eot
				INSERT INTO contact_list_robocalls
				SELECT
					nextval('contact_list_robocalls_id_seq') AS id, 
					r.*, now() AS created_at, now() AS updated_at
				FROM
				(SELECT 
					DISTINCT "voters"."phone", "contact_list_voters"."contact_list_id"
				FROM 
					"contact_list_voters", "voters"
				WHERE
					("contact_list_voters"."contact_list_id" = #{self.id})
				AND
					"voters"."id" = "contact_list_voters"."voter_id") AS r;		
			eot
	
			sql_result = ActiveRecord::Base.connection.execute(sql)
			build_file	
			self.constituent_count = self.contact_list_surveys.count
			self.populated = true
			self.repopulate = false
			self.save!
		elsif self.upload_list == true
			if !self.need_mapping == true
				#build list of survey results from uploaded file.
				 importer = ListImporter.new(		self.survey_attachments.last.file_name, 'survey', self.id, (self.mapped_fields.blank? ? nil : instance_eval(self.mapped_fields)))
				 importer.import!										
				build_file
				self.constituent_count = self.voters.count
				self.populated = true
				self.repopulate = false
				self.save!
			end

		end			

		#if self.populated == true && self.repopulate == false
		#	full_file_name = "#{RAILS_ROOT}/docs/survey_#{self.id}.csv"
		#	file_name = "survey_#{self.id}.csv"
		#	self.contact_list_surveys.report_table(:all, :methods => ['phone_number'], :only => ['phone_number']).save_as(full_file_name)
		#end

	end

	def build_file
#		full_file_name = "#{RAILS_ROOT}/docs/survey_#{self.id}.csv"
#		file_name = "survey_#{self.id}.csv"
#		self.voters.report_table(:all, :include => { :address => { :methods => :full_street_address, :only => ['city','state','zip5','zip4','county_name','cd','sd','hd','comm_dist_code','precinct_code'] } }, :only => ['first_name','middle_name','last_name','suffix','phone','home_phone','work_phone','work_phone_ext','cell_phone','email','age','sex','party','dob','dor','state_file_id']).save_as(full_file_name)

		File.open("#{RAILS_ROOT}/docs/survey_#{self.id}.csv", 'w') do |f|
			self.voters.all(:include => :address, :select => "addresses.precinct_code").each_with_index do |voter,index|
				if index==0
					build_header(f,voter)
				end
				write_record(f,voter)
			end
		end

	end

def build_header(f, line)
	s = "\"first_name\"," +
	 "\"middle_name\","	+
	 "\"last_name\"," +
	 "\"suffix\"," +			
	 "\"phone\"," +
	 "\"home_phone\"," +
	 "\"work_phone\"," +
	 "\"work_phone_ext\"," +
	 "\"cell_phone\"," +
	 "\"email\"," +
	 "age," +
	 "\"sex\"," +
	 "\"party\"," +
	 "\"dob\"," +
	 "\"dor\"," +
	 "\"state_file_id\"," +
	 "\"full_street_address\"," +
	 "\"city\"," +
	 "\"state\"," +
	 "\"zip5\"," +
	 "\"zip4\"," +
	 "\"county_name\"," +
	 "\"cd\"," +
	 "\"sd\"," +
	 "\"hd\"," +
	 "\"comm_dist_code\"," +
	 "\"precinct_code\"," 

	#now we need to add each question as a column from this survey
	self.questions.each do |question|
		 s += "\"#{question.question_text}\","
	end
	s = s[0, s.length-1] 
	 
	f.puts s	
	#f.puts "\""+line.attributes.keys.join('","')+"\""
end

def write_record(f,line)
	s = "\"#{line.first_name}\"," +
	 "\"#{line.middle_name}\","	+
	 "\"#{line.last_name}\"," +
	 "\"#{line.suffix}\"," +			
	 "\"#{line.phone}\"," +
	 "\"#{line.home_phone}\"," +
	 "\"#{line.work_phone}\"," +
	 "\"#{line.work_phone_ext}\"," +
	 "\"#{line.cell_phone}\"," +
	 "\"#{line.email}\"," +
	 "#{line.age}," +
	 "\"#{line.sex}\"," +
	 "\"#{line.party}\"," +
	 "\"#{line.dob}\"," +
	 "\"#{line.dor}\"," +
	 "\"#{line.state_file_id}\"," +
	 "\"#{line.address.full_street_address}\"," +
	 "\"#{line.address.city}\"," +
	 "\"#{line.address.state}\"," +
	 "\"#{line.address.zip5}\"," +
	 "\"#{line.address.zip4}\"," +
	 "\"#{line.address.county_name}\"," +
	 "\"#{line.address.cd}\"," +
	 "\"#{line.address.sd}\"," +
	 "\"#{line.address.hd}\"," +
	 "\"#{line.address.comm_dist_code}\"," +
	 "\"#{line.address.precinct_code}\"," 

	#now we need to add each questions answer from the voter as a column from this survey
	self.questions.each do |question|
		a = nil
		a = line.survey_results.find_by_contact_list_id_and_question_id(self.id, question.id)
		if a.nil?
			s+= "\"\","
		else
	    s += "\"#{question.answers.find_by_answer_key(a.answer).answer_text rescue a.answer}\","
	  end
	end
	s = s[0, s.length-1] 

	f.puts s	

	#f.puts "\""+line.attributes.values.join('","')+"\""
end

	#===== CLASS METHODS ======
	
end

