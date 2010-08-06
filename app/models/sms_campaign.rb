class SmsCampaign < Campaign

	CAMPAIGN_STATUSES = [
		# Displayed         stored in db
		[ "n/a",	        "n/a" ],
		[ "Scheduled",			"Scheduled" ],
		[ "Sending",				"Sending" ],
		[ "Sent",				    "Sent" ]
	]

	#====== ASSOCIATIONS =======
	belongs_to :contact_list

	#====== VALIDATIONS =======
	validates_datetime :scheduled_at, 
		:after => lambda { Time.zone.now - 1.minute }, 
		:if => :do_scheduling?
	validates_presence_of :sms_text, :if => :do_scheduling?

	#====== EVENTS ======
	def after_save
		if !self.schedule_at.nil? && self.delayed_job_id.blank?
			self.schedule_send_job!
		else
			true
		end
	end

	#====== INSTANCE METHODS ======
	def do_scheduling?
		!self.scheduled_at.blank?
	end

	def schedule_send_job!
		@job = Delayed::Job.enqueue(SmsCampaignSendJob.new(self.id), 3, self.scheduled_at) #3 = highest priority
		self.delayed_job_id = @job.id
		save!
	end

	def is_deleteable?
		return true if ['n/a','Sent'].include?(self.status)
		false
	end

	def is_editable?
		return true if self.status == 'n/a'
		return true if self.scheduled_at.nil?
		return true if self.scheduled_at > Time.zone.now + 2.hours
		false
	end

	def status
		if !self.schedule_at.nil?
			job = self.background_job
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
		job = self.background_job
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
	def self.send!(sms_campaign_id)
		@sms_campaign = SmsCampaign.find(sms_campaign_id)
		@sms_list = @sms_campaign.contact_list
		sms = ClubTexting.new(@sms_campaign.sms_text, @sms_list.contact_list_smsses.unsent)
		sms.send_messages!
	end

end

