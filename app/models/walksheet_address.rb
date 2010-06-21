class WalksheetAddress < ActiveRecord::Base

	#===== ASSOCIATIONS ======
	belongs_to :walksheet
	belongs_to :address

end
