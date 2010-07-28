class SmsList < ContactList
	acts_as_reportable

	CAMPAIGN_STATUSES = [
		# Displayed         stored in db
		[ "n/a",	        "n/a" ],
		[ "Scheduled",			"Scheduled" ],
		[ "Sending",				"Sending" ],
		[ "Sent",				    "Sent" ]
	]

	#====== ASSOCIATIONS =======
	has_one :sms_list_attachment, :as => :attachable
	accepts_nested_attributes_for :sms_list_attachment
	
	#====== VALIDATIONS =======
	validates_datetime :scheduled_at, 
		:after => lambda { Time.zone.now }, 
		:if => :do_scheduling?
	validates_presence_of :sms_text, :if => :do_scheduling?

	#====== EVENTS ======
	def before_save
		self.scheduled_at = nil if self.schedule != true
		true
		super
	end

	def after_save
		if self.schedule == true && self.delayed_job_id.blank?
			self.schedule_send_job!
		else
			true
		end
	end

	#====== INSTANCE METHODS =======	
	def schedule_send_job!
		@job = Delayed::Job.enqueue(SmsListSendJob.new(self.id), 3, self.scheduled_at) #3 = highest priority
		self.delayed_job_id = @job.id
		save!
	end
	
	def do_scheduling?
		self.schedule
	end
	
	def contact_list_id
		self.id
	end
	
	def filename(format)
		"sms_list_#{self.id}.#{format}"
	end

	def status
		if self.schedule == true
			job = self.delayed_job
			if !self.delayed_job_id.nil?
				if !job.nil?
					if !job.last_error.nil? 
						'Failed'
					elsif !job.locked_at.nil?
						'Sending'
					else
						'Scheduled'
					end
				else
					'Sent'
				end
			else
				'n/a'
			end
		else
			'n/a'
		end
	end

	def status_display
		job = self.delayed_job
		s = self.status
		d = nil

		d = case s
			when 'Sent' then format_date_time(self.scheduled_at)
			when 'Scheduled' then format_date_time(self.scheduled_at)
			when 'Sending' then format_date_time(job.locked_at)
			when 'Failed' then format_date_time(self.scheduled_at)	
			else ''			
		end
		d = ': ' + d unless d.blank?
		s+d
	end

	#===== CLASS METHODS ======
	def self.send!(sms_list_id)
		@sms_list = SmsList.find(sms_list_id)
		sms = ClubTexting.new(@sms_list.sms_text, @sms_list.contact_list_smsses.unsent)
		sms.send_messages!
	end
	
end

