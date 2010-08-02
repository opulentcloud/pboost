class RobocallListAttachment < Attachment
	has_attached_file :data,
		:url => "docs/robocall_lists/:id/:basename.:extension",
		:path => "docs/robocall_lists/:id/:basename.:extension"

end

