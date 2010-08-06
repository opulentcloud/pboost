class Campaign < ActiveRecord::Base

	CAMPAIGN_STATUSES = [
		# Displayed         stored in db
		[ "n/a",	        "n/a" ],
		[ "Scheduled",			"Scheduled" ],
		[ "Sending",				"Sending" ],
		[ "Sent",				    "Sent" ]
	]

	#===== VALIDATIONS ======
	validates_presence_of :name
	validates_acceptance_of :acknowledgement, :accept => true, :message => 'You must  accept the terms of submitting this Campaign'

	#===== ASSOCIATIONS =====
	belongs_to :contact_list
	has_one :political_campaign, :through => :contact_list

	def campaign_type
		self.class.to_s.gsub('Campaign','')
	end

	def format_date(date_time)
		date_time.strftime '%m/%d/%Y'
	end

	def format_date_time(date_time)
		date_time.strftime '%m/%d/%Y %I:%M %p %Z'
	end
	
end

