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

	#===== VALIDATIONS ======
	validates_presence_of :name
	validates_uniqueness_of :name, :scope => :political_campaign_id
	validates_associated :sex_filter
	
	#===== EVENTS =====
	def before_save
		if self.sex_filter
			self.sex_filter = nil if self.sex_filter.string_val == 'A'
		end
		
		if self.age_filter
			self.age_filter = nil if self.age_filter.int_val == 0 && self.age_filter.max_int_val == 0
		end

		self.party_filters.each do |pf|
			pf.destroy if pf.string_val == "0"
		end
		
	end

	def before_destroy
		return if self.new_record?
		sql = "DELETE FROM walksheet_addresses WHERE walksheet_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
				
		sql = "DELETE FROM walksheet_voters WHERE walksheet_id = #{self.id}"
		ActiveRecord::Base.connection.execute(sql)
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
		political_campaign = self.political_campaign

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

		sql1 = sql1_header + sql
		sql_result = ActiveRecord::Base.connection.execute(sql1)

		self.constituent_count = self.voters.count
		self.populated = true
		self.save!	
	
	end

	#===== CLASS METHODS ======
	def self.populate(walksheet_id)
		walksheet = Walksheet.find(walksheet_id)
		
		if walksheet.nil?
			rails ActiveRecord::RecordNotFound
		end
		walksheet.populate
	end

end
