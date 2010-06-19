class Constituent < ActiveRecord::Base

	#===== ASSOCIATIONS =====
	belongs_to :political_campaign
	belongs_to :voter
	
end
