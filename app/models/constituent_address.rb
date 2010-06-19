class ConstituentAddress < ActiveRecord::Base

	#===== ASSOCIATIONS ======
	belongs_to :political_campaign
	belongs_to :address

end
