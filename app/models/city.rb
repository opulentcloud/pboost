class City < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'cities.name'

	#====== ASSOCIATIONS ======
	belongs_to :county
	has_one :state, :through => :county
	has_and_belongs_to_many :council_districts

end
