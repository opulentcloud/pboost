class CampaignSmss < ActiveRecord::Base
	acts_as_reportable

	#===== SCOPES ======
	named_scope :unsent, :conditions => 'campaign_smsses.status IS NULL'

	#====== ASSOCIATIONS ======
	belongs_to :campaign
	has_one :contact_list, :through => :campaign
	
	def send_status_display
		ClubTexting.translate_response(self.status)
	end
	
end
