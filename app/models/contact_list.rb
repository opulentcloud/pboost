class ContactList < ActiveRecord::Base

	#===== ACCESSORS =====
	attr_accessor_with_default :repopulate, false
	attr_accessor :file_name, :route_index, :current_voter_count
	
	def do_mapping
		@do_mapping
	end
	
	def do_mapping=(value)
		@do_mapping = [true,'true',1,'1','T','t'].include?(value.class == String ? value.downcase : value)
	end
	
#	def upload_list=(value)
#		@upload_list = [true,'true',1,'1','T','t'].include?(value.class == String ? value.downcase : value)
#	end
	
	#===== SCOPES ======
	default_scope :order => 'contact_lists.name'
	named_scope :populated, :conditions => 'contact_lists.populated = true'

	#===== ASSOCIATIONS =====
	belongs_to :political_campaign
	has_one :precinct_filter, :dependent => :destroy
	accepts_nested_attributes_for :precinct_filter
	has_one :council_district_filter, :dependent => :destroy
	accepts_nested_attributes_for :council_district_filter
	has_one :municipal_district_filter, :dependent => :destroy
	accepts_nested_attributes_for :municipal_district_filter
	has_one :age_filter, :dependent => :destroy
	accepts_nested_attributes_for :age_filter
	has_one :sex_filter, :dependent => :destroy
	accepts_nested_attributes_for :sex_filter
	has_many :party_filters, :dependent => :destroy
	accepts_nested_attributes_for :party_filters
	has_many :parties, :through => :party_filters
	has_many :contact_list_voters
	has_many :voters, :through => :contact_list_voters
	has_many :contact_list_addresses
	has_many :addresses, :through => :contact_list_addresses
	has_one :gis_region_filter, :dependent => :destroy
	accepts_nested_attributes_for :gis_region_filter
	has_one :gis_region, :dependent => :destroy
	accepts_nested_attributes_for :gis_region
	has_many :voting_history_filters, :dependent => :destroy
	accepts_nested_attributes_for :voting_history_filters
	has_many :elections, :through => :voting_history_filters
	has_one :voting_history_type_filter
	accepts_nested_attributes_for :voting_history_type_filter
	has_many :contact_list_smsses
	belongs_to :background_job, :dependent => :destroy
	has_many :contact_list_robocalls
	has_many :campaigns
	has_many :robocall_campaigns
	has_many :sms_campaigns
	has_many :questions, :class_name => 'SurveyQuestion', :dependent => :destroy
	accepts_nested_attributes_for :questions
	has_many :results, :class_name => 'VoterSurveyResult', :dependent => :destroy

	#===== VALIDATIONS ======
	validates_presence_of :name
	validates_uniqueness_of :name, :scope => :political_campaign_id
	validates_associated :sex_filter
	validate :valid_geo_filters, :if => Proc.new { |c| c.class.to_s == 'Walksheet' }
	
	#===== EVENTS =====
	def valid_geo_filters
		if self.precinct_filter
			return true if !self.precinct_filter.string_val.blank?		
		end

		if self.gis_region
			return true if !self.gis_region.geom2.nil? || !self.gis_region.vertices.blank?
		end

		errors.add_to_base('You must use a Geographic filter (either choose a Precinct or Draw at least one Route on the map)')
	end
	
	def after_create
		self.voting_history_filters.each do |vh|
			vh.destroy if vh.string_val.nil?
		end

		if self.voting_history_type_filter
			self.voting_history_type_filter = nil if self.voting_history_filters.size == 0
		end
		
		true
	end

	def before_save
#debugger
		if self.gis_region
			self.gis_region = nil if self.gis_region.geom2.blank?
		end

		if self.precinct_filter
			self.precinct_filter = nil if self.precinct_filter.string_val.blank?
		end

		if self.municipal_district_filter
			self.municipal_district_filter = nil if self.municipal_district_filter.string_val.blank?
		end
		
		if self.council_district_filter
			self.council_district_filter = nil if self.council_district_filter.string_val.blank?
		end
	
		if self.gis_region_filter
			self.gis_region_filter = nil if self.gis_region_filter.int_val == nil
		end

		if self.sex_filter
			self.sex_filter = nil if self.sex_filter.string_val == 'A'
		end
		
		if self.age_filter
			self.age_filter = nil if self.age_filter.int_val == 0 && self.age_filter.max_int_val == 0
		end

		self.party_filters.each do |pf|
			pf.destroy if pf.string_val == "0"
		end
		
		true
	end

	def before_destroy
		return false if self.campaigns.count > 0
		return if self.new_record?
		sql = "DELETE FROM contact_list_addresses WHERE contact_list_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
				
		sql = "DELETE FROM contact_list_voters WHERE contact_list_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)

		case self.class.to_s
			when 'RobocallList' then
				sql = "DELETE FROM contact_list_robocalls WHERE contact_list_id = #{self.id}"
				ActiveRecord::Base.connection.execute(sql)

			when 'SmsList' then
				sql = "DELETE FROM contact_list_smsses WHERE contact_list_id = #{self.id}"
				ActiveRecord::Base.connection.execute(sql)

			when 'Survey' then
				#sql = "DELETE FROM contact_list_surveys WHERE contact_list_id = #{self.id}"
				#ActiveRecord::Base.connection.execute(sql)

		end

		true
	end

	def after_destroy
		return true unless ['Walksheet','Survey','SmsList','PhoneBankList','RobocallList'].include?(self.class.to_s)
		delete_file
	end

	#===== INSTANCE METHODS =====
	def route_count
		return 0 if self.gis_region.nil?
		self.gis_region.geom2.size
	end
	
	def delete_file
		fname = "#{RAILS_ROOT}/docs/canvass_list_#{self.id}.pdf"
		if File.exists?(fname)
			begin
				File.delete(fname)
			rescue
			end
		end

		fname = "#{RAILS_ROOT}/docs/canvass_list_route_*_#{self.id}.pdf"
		if File.exists?(fname)
			begin
				File.delete(fname)
			rescue
			end		
		end
		
		fname = "#{RAILS_ROOT}/docs/sms_list_#{self.id}.csv"
		if File.exists?(fname)
			begin
				File.delete(fname)
			rescue
			end		
		end

		fname = "#{RAILS_ROOT}/docs/phone_bank_list_#{self.id}.csv"
		if File.exists?(fname)
			begin
				File.delete(fname)
			rescue
			end		
		end

		fname = "#{RAILS_ROOT}/docs/robocall_list_#{self.id}.csv"
		if File.exists?(fname)
			begin
				File.delete(fname)
			rescue
			end		
		end

		fname = "#{RAILS_ROOT}/docs/survey_#{self.id}.csv"
		if File.exists?(fname)
			begin
				File.delete(fname)
			rescue
			end		
		end
		
	end
	
	def is_editable?
		self.populated
	end
	
	def party_filter_symbols
		party_filters.map do |party|
			party.name.downcase.underscore.to_sym
		end	
	end

	def populate
		delete_file if ['Walksheet','Survey','SmsList','PhoneBankList','RobocallList'].include?(self.class.to_s)

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

			if self.id == 267
				sql += <<-eot
					AND ("addresses"."hd" IN ('23A','23B','024','025','026','27A')) 
				eot
			end

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

=begin
			if self.gis_region_filter
				sql += <<-eot
					AND EXISTS (
					SELECT * FROM "gis_regions_voters" WHERE
					"gis_regions_voters"."gis_region_id" = #{self.gis_region_filter.int_val}
					AND "gis_regions_voters"."voter_id" = "voters"."id") 
				eot
			end
=end			
			if self.age_filter
				sql += <<-eot
					AND
						("voters"."age" BETWEEN #{self.age_filter.int_val} AND #{self.age_filter.max_int_val})
				eot
			end

			if self.sex_filter
				sql += <<-eot
					AND
						("voters"."sex" = '#{self.sex_filter.string_val}')
				eot
			end

			if self.party_filters.size > 0
				@in = self.party_filters.map { |f| "'"+Party.find(f.int_val).code+"'" }.join(',')
				sql += <<-eot
					AND
						("voters"."party" IN (#{@in}))
				eot
			end

			if self.voting_history_filters.size > 0
				sql += case self.voting_history_type_filter.string_val
					when 'Any' then build_any_voting_history_query
					when 'All' then build_all_voting_history_query
					when 'At Least' then build_at_least_voting_history_query
					when 'Exactly' then build_exactly_voting_history_query
					when 'No More Than' then build_no_more_than_voting_history_query
				end
			end

		if self.class.to_s == 'PhoneBankList' || self.class.to_s == 'RobocallList'
			sql += <<-eot
				AND ("voters"."phone" != '') 
			eot
		end

		if self.class.to_s == 'SmsList'
			sql2_header = ";"
		else #Walksheet, PhoneBankList and RobocallList need to do this.

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
		
		end

		sql1 = sql1_header + sql + '; ' + sql2_header
		logger.debug(sql1)
		sql_result = ActiveRecord::Base.connection.execute(sql1)

		if self.voters.count > 0
			case self.class.to_s
				when 'Walksheet' then	WalksheetReport.build(self)
			end
		end

		end #end if !self.upload_list == true

		case self.class.to_s
			when 'PhoneBankList' then
				full_file_name = "#{RAILS_ROOT}/docs/phone_bank_list_#{self.id}.csv"
				file_name = "phone_bank_list_#{self.id}.csv"
				self.voters.report_table(:all, :include => { :address => { :methods => :full_street_address, :only => ['city','state','zip','comm_dist_code','precinct_code'] } }, :only => ['first_name','middle_name','last_name','suffix','phone','age','sex','party','state_file_id']).save_as(full_file_name)
				self.constituent_count = self.voters.count
			when 'Walksheet' then
				self.constituent_count = self.voters.count
		end
		
		self.populated = true
		self.repopulate = false
		self.save!

	end

	#===== CLASS METHODS ======
	def self.populate(contact_list_id)
		contact_list = ContactList.find(contact_list_id)

		if contact_list.nil?
			raise ActiveRecord::RecordNotFound
		end
		
		contact_list.populate
	end

	#===== PRIVATE CLASS METHODS ======
private
	def build_no_more_than_voting_history_query
		sql = build_x_limit_query
		sql += " <= #{self.voting_history_type_filter.int_val})"
	end

	def build_exactly_voting_history_query
		sql = build_x_limit_query
		sql += " = #{self.voting_history_type_filter.int_val})"
	end

	def build_at_least_voting_history_query
		sql = build_x_limit_query
		sql += " >= #{self.voting_history_type_filter.int_val})"
	end

	def build_x_limit_query
		sql = 'AND ('
		query_type = nil

		self.voting_history_filters.each do |f|
			next if f.string_val.blank?
			e = Election.find(f.int_val)
			vt = VotingHistoryFilter::VOTING_TYPES.map { |disp,value| [disp,value] }.to_a

			vt.each do |a|
				if a[0] == f.string_val 
					query_type = a[1]
					break
				end
			end
			
			case query_type
				when 'Voted' then
					sql += "(SELECT COUNT(*) FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}') + "
				when 'Didn\'t Vote' then
					sql += "CASE (SELECT COUNT(*) FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}') WHEN 0 THEN 1 ELSE 0 END + "
				else
					sql += "(SELECT COUNT(*) FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}' AND \"voting_history_voters\".\"voter_type\" = '#{query_type}' ) + "
			end
		end

		sql = sql[0,sql.length-3]
	
	end

	def build_all_voting_history_query
		sql = build_any_voting_history_query
		sql.gsub(' OR ', ' AND ')
	end

	def build_any_voting_history_query
		sql = 'AND ('
		query_type = nil

		self.voting_history_filters.each do |f|
			next if f.string_val.blank?
			e = Election.find(f.int_val)
			vt = VotingHistoryFilter::VOTING_TYPES.map { |disp,value| [disp,value] }.to_a

			vt.each do |a|
				if a[0] == f.string_val 
					query_type = a[1]
					break
				end
			end
			
			case query_type
				when 'Voted' then
					sql += "EXISTS (SELECT * FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}') OR "
				when 'Didn\'t Vote' then
					sql += "NOT EXISTS (SELECT * FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}') OR "
				else
					sql += "EXISTS (SELECT * FROM \"voting_history_voters\" WHERE \"voting_history_voters\".\"voter_id\" = \"voters\".\"id\" AND \"voting_history_voters\".\"election_year\" = #{e.year} AND \"voting_history_voters\".\"election_type\" = '#{e.election_type}' AND \"voting_history_voters\".\"voter_type\" = '#{query_type}' ) OR "
			end
		end

		sql = sql[0,sql.length-4]
		sql += ')'
	end
	
	def format_date(date_time)
		date_time.strftime '%m/%d/%Y'
	end

	def format_date_time(date_time)
		date_time.strftime '%m/%d/%Y %I:%M %p %Z'
	end
	
end
