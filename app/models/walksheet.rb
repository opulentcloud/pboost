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

	#===== METHODS =====
	def party_filter_symbols
		party_filters.map do |party|
			party.name.downcase.underscore.to_sym
		end	
	end

end
