class SmsListAttachment < Attachment
	has_attached_file :data,
		:url => "docs/sms_lists/:id/:basename.:extension",
		:path => "docs/sms_lists/:id/:basename.:extension"

end

