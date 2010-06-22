class Walksheet < ActiveRecord::Base
	#===== SCOPES ======
	default_scope :order => 'walksheets.name'

	#===== ASSOCIATIONS =====
	belongs_to :political_campaign
	has_one :age_filter, :dependent => :destroy
	accepts_nested_attributes_for :age_filter
	has_one :sex_filter, :dependent => :destroy
	accepts_nested_attributes_for :sex_filter
	has_many :party_filters, :dependent => :destroy
	accepts_nested_attributes_for :party_filters
	has_many :parties, :through => :party_filters
	has_many :walksheet_voters
	has_many :voters, :through => :walksheet_voters
	has_many :walksheet_addresses
	has_many :addresses, :through => :walksheet_addresses
	has_one :gis_region_filter, :dependent => :destroy
	accepts_nested_attributes_for :gis_region_filter

	#===== VALIDATIONS ======
	validates_presence_of :name
	validates_uniqueness_of :name, :scope => :political_campaign_id
	validates_associated :sex_filter
	
	#===== EVENTS =====
	def before_save
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
		return if self.new_record?
		sql = "DELETE FROM walksheet_addresses WHERE walksheet_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
				
		sql = "DELETE FROM walksheet_voters WHERE walksheet_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
		true
	end

	#===== INSTANCE METHODS =====
	def is_editable?
		self.populated
	end
	
	def party_filter_symbols
		party_filters.map do |party|
			party.name.downcase.underscore.to_sym
		end	
	end

	def populate

		#unlink any addresses from this walksheet
		sql = "DELETE FROM walksheet_addresses WHERE walksheet_id = #{self.id}"
		sql_result = ActiveRecord::Base.connection.execute(sql)
				
		#unlink any voters from this walksheet
		sql = "DELETE FROM walksheet_voters WHERE walksheet_id = #{self.id}"
		sql_result = ActiveRecord::Base.connection.execute(sql)

		sql1_header = <<-eot
			INSERT INTO walksheet_voters
			SELECT 
				nextval('walksheet_voters_id_seq') AS id, 
				 "walksheets"."id", "voters"."id", now() AS created_at, now() AS updated_at 
			FROM 
				"walksheets", "constituents", "voters"
			WHERE
				("walksheets"."id" = #{self.id})
			AND
				("constituents"."political_campaign_id") = "walksheets"."political_campaign_id" 
			AND
				("voters"."id" = "constituents"."voter_id")
		eot
			
			sql = ''

			if self.gis_region_filter
				sql += <<-eot
					AND EXISTS (
					SELECT * FROM "gis_regions_voters" WHERE
					"gis_regions_voters"."gis_region_id" = #{self.gis_region_filter.int_val}
					AND "gis_regions_voters"."voter_id" = "voters"."id") 
				eot
			end
			
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

		sql2_header = <<-eot
			INSERT INTO walksheet_addresses
			SELECT
				nextval('walksheet_addresses_id_seq') AS id, 
				r.*, now() AS created_at, now() AS updated_at
			FROM
			(SELECT 
				DISTINCT "walksheet_voters"."walksheet_id", "voters"."address_id" 
			FROM 
				"walksheet_voters", "voters"
			WHERE
				("walksheet_voters"."walksheet_id" = #{self.id})
			AND
				"voters"."id" = "walksheet_voters"."voter_id") AS r;		
			eot

		sql1 = sql1_header + sql + '; ' + sql2_header
		sql_result = ActiveRecord::Base.connection.execute(sql1)

		self.constituent_count = self.voters.count
		self.populated = true
		self.save!	
	
	end

	#===== CLASS METHODS ======
	def self.populate(walksheet_id)
		walksheet = Walksheet.find(walksheet_id)
		
		if walksheet.nil?
			raise ActiveRecord::RecordNotFound
		end
		walksheet.populate
	end

end
