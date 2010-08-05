class AnswerMachineAttachment < Attachment
	has_attached_file :data,
		:url => "docs/answer_machine/:id/:basename.:extension",
		:path => "docs/answer_machine/:id/:basename.:extension"

	validates_attachment_content_type :data,
		:content_type => ['application/mp3','application/x-mp3','audio/mpeg','audio/mp3','audio/mpg','audio/mpeg3','application/wav','application/x-wav','audio/wav','audio/x-wav'], :message => 'The file you have attempted to upload is not an acceptable type. Valid types are .mp3 and .wav'

end

