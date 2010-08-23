class SurveyAttachment < Attachment
	default_scope :order => :id

	has_attached_file :data,
		:url => "docs/surveys/:id/:basename.:extension",
		:path => "docs/surveys/:id/:basename.:extension"

	validates_attachment_content_type :data,
		:content_type => ['text/x-csv','text/csv','text/plain','text/x-comma-separated-values','text/comma-separated-values','application/csv','application/x-csv','application/vnd.ms-excel','application/excel','application/vnd.msexcel'], :message => 'The file you have attempted to upload is not an acceptable type.'
	
end

