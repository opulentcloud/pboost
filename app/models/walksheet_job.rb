class WalksheetJob < Struct.new(:walksheet_id)
	def perform
		Walksheet.populate(walksheet_id)
	end
end
