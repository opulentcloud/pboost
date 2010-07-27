class SmsList < ContactList
	acts_as_reportable

	CAMPAIGN_STATUSES = [
		# Displayed         stored in db
		[ "n/a",	        "n/a" ],
		[ "Scheduled",			"Scheduled" ],
		[ "Sending",				"Sending" ],
		[ "Sent",				    "Sent" ]
	]
	
	#====== VALIDATIONS =======
	validates_datetime :scheduled_at, 
		:after => lambda { Time.zone.now }, 
		:if => :do_scheduling?

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
					if !job.failed_at.nil? 
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
			when 'Failed' then format_date_time(job.failed_at)	
			else ''			
		end
		d = ': ' + d unless d.blank?
		s+d
	end

	#===== CLASS METHODS ======
	def self.send!(sms_list_id)
		@sms_list = SmsList.find(sms_list_id)
		sleep 60
		@sms_list.scheduled_at = Time.zone.now
		@sms_list.save!
	end
	
end

