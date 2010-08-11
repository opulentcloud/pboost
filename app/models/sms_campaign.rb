class SmsCampaign < Campaign

	CAMPAIGN_STATUSES = [
		# Displayed         stored in db
		[ "n/a",	        	"n/a" ],
		[ "Populating",			"Populating" ],
		[ "Scheduling",			"Scheduling" ],
		[ "Scheduled",			"Scheduled" ],
		[ "Sending",				"Sending" ],
		[ "Sent",				    "Sent" ]
	]

	#====== ASSOCIATIONS =======
	belongs_to :sms_list, :foreign_key => :contact_list_id

	#====== VALIDATIONS =======
	validates_datetime :scheduled_at, 
		:after => lambda { Time.zone.now - 1.minutes }, 
		:if => :do_scheduling?
	validates_presence_of :sms_text, :if => :do_scheduling?
	validates_presence_of :contact_list_id

	#====== EVENTS ======
	def before_save
		if self.scheduled_at_changed? && !self.delayed_job_id.blank?
			j = self.background_job
			if self.scheduled_at.blank?
				j.destroy
				self.delayed_job_id = nil
			else
				j.run_at = self.scheduled_at
				j.save
			end
		end
	end
	
	def after_save
		if !self.scheduled_at.nil? && self.delayed_job_id.blank?
			self.schedule_send_job!
		else
			true
		end
	end

	#====== INSTANCE METHODS ======
	def product
		Product.find_by_name('SMS Message')
	end
	
	def calc_quantity
		if self.populated == true
			self.voter_count
		else
			self.sms_list.constituent_count
		end
	end
	
	def calc_total_price
		sms_count = self.quantity
		(sms_count.to_f * product.unit_price).round(2)
	end
	
	def do_scheduling?
		!self.scheduled_at.blank?
	end

	def schedule_send_job!
		@job = Delayed::Job.enqueue(SmsCampaignSendJob.new(self.id), 3, self.scheduled_at) #3 = highest priority
		self.delayed_job_id = @job.id
		save!
	end

	def is_deleteable?
		return false if !self.populated == true
		return true if ['n/a','Sent'].include?(self.status)
		false
	end

	def is_editable?
		return false if !self.populated == true
		return true if self.status == 'n/a'
		return true if self.scheduled_at.nil?
		return true if self.scheduled_at > Time.zone.now + 1.minutes
		false
	end

	def status
		return 'Populating' if !self.populated == true
		
		if !self.scheduled_at.nil?
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

	def populate

		sql = <<-eot
			INSERT INTO campaign_smsses
				SELECT nextval('campaign_smsses_id_seq') AS id, 
				"contact_list_smsses"."cell_phone", 
				NULL AS status, #{self.id} AS campaign_id,
				now() AS created_at, now() AS updated_at
			FROM 
				"contact_list_smsses"
			WHERE
				("contact_list_smsses"."contact_list_id" = #{self.contact_list_id})
			eot
		
		sql_result = ActiveRecord::Base.connection.execute(sql)
		self.voter_count = self.campaign_smsses.count
		self.populated = true
		self.repopulate = false
		self.save!

	end

	#===== CLASS METHODS ======
	def self.send!(sms_campaign_id)
		@sms_campaign = SmsCampaign.find(sms_campaign_id)
		# need to wait until we have populated
		if !@sms_campaign.populated == true
			@job = Delayed::Job.enqueue(SmsCampaignSendJob.new(@sms_campaign.id), 3, Time.zone.now + 2.minutes) #3 = highest priority
			self.delayed_job_id = @job.id
			save!
			return
		end
		
		sms = ClubTexting.new(@sms_campaign.sms_text, @sms_campaign.campaign_smsses.unsent)
		sms.send_messages!
	end

	def self.calc_total_price(contact_list_id)
		sms_campaign = SmsCampaign.new
		sms_campaign.contact_list_id = contact_list_id
		sms_campaign.calc_total_price
	end

end

