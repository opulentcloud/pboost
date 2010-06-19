class Walksheet < ActiveRecord::Base
	#===== PROPERTIES ======
  attr_accessible :name, :consituent_count, :populated

	#===== SCOPES ======
	default_scope :order => 'walksheets.name'

	#===== ASSOCIATIONS =====
	belongs_to :political_campaign

end
