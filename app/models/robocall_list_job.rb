class RobocallListJob < Struct.new(:robocall_list_id)
	def perform
		RobocallList.populate(robocall_list_id)
	end
end
