class County < ActiveRecord::Base

	#===== SCOPES ======
	default_scope :order => 'counties.name'

	#====== ASSOCIATIONS ======
	belongs_to :state
	has_many :cities

end
