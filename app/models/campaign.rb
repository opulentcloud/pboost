class Campaign < ActiveRecord::Base

	#===== SCOPES ======
	named_scope :scheduled, :order => :created_at, :conditions => ["campaigns.scheduled_at IS NOT NULL AND campaigns.scheduled_at >= ?", Time.zone.now]

	#===== CLASS ACCESSORS =====
	attr_accessor_with_default :repopulate, false

	#===== VALIDATIONS ======
	validates_presence_of :name
	validates_acceptance_of :acknowledgement, :accept => true, :message => 'You must accept the terms of submitting this Campaign'

	#===== ASSOCIATIONS =====
	belongs_to :contact_list
	has_many :campaign_smsses
	has_one :political_campaign, :through => :contact_list
	belongs_to :background_job, :foreign_key => :delayed_job_id

	def campaign_type
		self.class.to_s.gsub('Campaign','')
	end

	def format_date(date_time)
		date_time.strftime '%m/%d/%Y'
	end

	def format_date_time(date_time)
		date_time.strftime '%m/%d/%Y %I:%M %p %Z'
	end

	#===== CLASS METHODS ======
	def self.populate(campaign_id)
		campaign = Campaign.find(campaign_id)

		if campaign.nil?
			raise ActiveRecord::RecordNotFound
		end
		
		campaign.populate
	end
	
end

