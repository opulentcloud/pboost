class Event < ActiveRecord::Base
	#===== ASSOCIATIONS =====
	belongs_to :eventable, :polymorphic => true
	belongs_to :contact_list
	belongs_to :send_event, :class_name => "SendEvent",
		:foreign_key => "contact_list_id"
	belongs_to :queued_event, :class_name => "QueuedEvent",
		:foreign_key => "contact_list_id"
	belongs_to :address
	belongs_to :voter
	has_one :organization, :through => :contact_list
	belongs_to :background_job
end

