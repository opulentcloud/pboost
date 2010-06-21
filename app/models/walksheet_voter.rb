class WalksheetVoter < ActiveRecord::Base

	#===== ASSOCIATIONS ======
	belongs_to :walksheet
	belongs_to :voter

end
