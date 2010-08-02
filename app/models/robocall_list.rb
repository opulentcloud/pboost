class RobocallList < ContactList
	acts_as_reportable

	CAMPAIGN_STATUSES = [
		# Displayed         stored in db
		[ "n/a",	        "n/a" ],
		[ "Scheduled",			"Scheduled" ],
		[ "Sending",				"Sending" ],
		[ "Sent",				    "Sent" ]
	]

	#====== ASSOCIATIONS =======
	has_one :robocall_list_attachment, :as => :attachable, :dependent => :destroy
	accepts_nested_attributes_for :robocall_list_attachment
	
	#====== VALIDATIONS =======
	validates_datetime :scheduled_at, 
		:after => lambda { Time.zone.now }, 
		:if => :do_scheduling?
	validates_presence_of :sms_text, :if => :do_scheduling?

	#====== EVENTS ======
	def before_save
		self.scheduled_at = nil if self.schedule != true
		true
		super
	end

	def after_save
		if self.schedule == true && self.delayed_job_id.blank?
			self.schedule_send_job!
		else
			true
		end
	end

	#====== INSTANCE METHODS =======	
	#determine if we need to ask the user which column is the phone number column if we have a manually uploaded file.
	def rows(x = 10)
		i = ListImporter.new(self.robocall_list_attachment.file_name, 'robocall_list', self.id)
		i.rows(x)
	end

	def need_mapping
	#debugger
		return false unless self.upload_list == true
		return false if self.mapped_fields.blank? == false
		return true if self.robocall_list_attachment.nil?
		 i = ListImporter.new(self.robocall_list_attachment.file_name, 'robocall_list', self.id)
		 i.need_mapping
	end

	def schedule_send_job!
		@job = Delayed::Job.enqueue(RobocallListSendJob.new(self.id), 3, self.scheduled_at) #3 = highest priority
		self.delayed_job_id = @job.id
		save!
	end
	
	def do_scheduling?
		self.schedule
	end
	
	def contact_list_id
		self.id
	end
	
	def filename(format)
		"robocall_list_#{self.id}.#{format}"
	end

	def status
		if self.schedule == true
			job = self.delayed_job
			if !self.delayed_job_id.nil?
				if !job.nil?
					if !job.last_error.nil? 
						'Failed'
					elsif !job.locked_at.nil?
						'Sending'
					else
						'Scheduled'
					end
				else
					'Sent'
				end
			else
				'n/a'
			end
		else
			'n/a'
		end
	end

	def status_display
		job = self.delayed_job
		s = self.status
		d = nil

		d = case s
			when 'Sent' then format_date_time(self.scheduled_at)
			when 'Scheduled' then format_date_time(self.scheduled_at)
			when 'Sending' then format_date_time(job.locked_at)
			when 'Failed' then format_date_time(self.scheduled_at)	
			else ''			
		end
		d = ': ' + d unless d.blank?
		s+d
	end

	def populate
		delete_file if ['RobocallList','SmsList'].include?(self.class.to_s)

		#unlink any addresses from this contact_list
		sql = "DELETE FROM contact_list_addresses WHERE contact_list_id = #{self.id}"
		sql_result = ActiveRecord::Base.connection.execute(sql)
				
		#unlink any voters from this contact_list
		sql = "DELETE FROM contact_list_voters WHERE contact_list_id = #{self.id}"
		sql_result = ActiveRecord::Base.connection.execute(sql)

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
				sql_temp = sql_temp.gsub("\"voters\".\"id\"", "v.id")
				sql += sql_temp
			end

		sql += <<-eot
			AND (v.phone != '')	ORDER BY v.sex DESC, v.age DESC LIMIT 1));
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
			#build list of robocall phone numbers from voters.
			self.voters.all(:select => 'DISTINCT voters.phone', :conditions => "voters.phone != ''").each do |voter|
				cls = ContactListRobocall.new
				cls.phone = voter.phone
				self.contact_list_robocalls << cls
			end

			self.constituent_count = self.contact_list_robocalls.count

			full_file_name = "#{RAILS_ROOT}/docs/robocall_list_#{self.id}.csv"
			file_name = "robocall_list_#{self.id}.csv"
			self.contact_list_robocalls.report_table(:all, :method => :phone_number).save_as(full_file_name)

			self.populated = true
			self.repopulate = false
			self.save!
		elsif self.upload_list == true
			if !self.need_mapping == true
				#build list of robocall phone numbers from uploaded file.
				 importer = ListImporter.new(self.robocall_list_attachment.file_name, 'robocall_list', self.id, (self.mapped_fields.blank? ? nil : instance_eval(self.mapped_fields)))
				 importer.import!										

				self.constituent_count = self.contact_list_robocalls.count

				full_file_name = "#{RAILS_ROOT}/docs/robocall_list_#{self.id}.csv"
				file_name = "robocall_list_#{self.id}.csv"
				self.contact_list_robocalls.report_table(:all, :method => :phone_number).save_as(full_file_name)

				self.populated = true
				self.repopulate = false
				self.save!
			end
		end			

	end

	#===== CLASS METHODS ======
	
end

