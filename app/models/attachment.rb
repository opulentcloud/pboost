class Attachment < ActiveRecord::Base
	has_attached_file :data
	belongs_to :attachable, :polymorphic => true

	#validates_attachment_size :data, :greater_than => 0.kilobytes	
	validates_attachment_content_type :data,
		:content_type => ['text/csv','text/plain'], :message => 'The file you have attempted to upload is not an acceptable type.'
	validates_attachment_presence :data
		
	def self.destroy_attachment(class_type, attachable_type, id)
		Attachment.find(id, :conditions => {:type => class_type, :attachable_type => attachable_type}).destroy	
	end
		
	def url(*args)
		data.url(*args)
	end
	
	def name
		data_file_name
	end
	
	def content_type
		data_content_type
	end
	
	def file_size
		data_file_size
	end
	
	def file_name
		"#{RAILS_ROOT}/#{self.url[0,self.url.index(self.name)] + self.name}"
	end
end

