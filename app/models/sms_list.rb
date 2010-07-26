class SmsList < ContactList
	acts_as_reportable

	CAMPAIGN_STATUSES = [
		# Displayed         stored in db
		[ "Draft",	        "Draft" ],
		[ "On Hold",				"On Hold" ],
		[ "Scheduled",			"Scheduled" ],
		[ "Scheduling",			"Scheduling" ],
		[ "Sending",				"Sending" ],
		[ "Sent",				    "Sent" ]
	]
	
	#====== VALIDATIONS =======
	validates_datetime :scheduled_at, 
		:after => lambda { Time.zone.now + 15.minutes }, 
		:if => :do_scheduling?

	#====== EVENTS ======
	def before_save
	debugger
		self.scheduled_at = nil if self.schedule != true
		true
		super
	end

	#====== INSTANCE METHODS =======	
	def do_scheduling?
		self.schedule
	end
	
	def contact_list_id
		self.id
	end
	
	def filename(format)
		"sms_list_#{self.id}.#{format}"
	end

	def status_display
		if self.schedule == true
				'Scheduled: ' + format_date_time(self.scheduled_at)
		else
			'n/a'
		end
	end
	
end

