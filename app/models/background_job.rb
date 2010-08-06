class BackgroundJob < ActiveRecord::Base
	set_table_name 'delayed_jobs'
	
	#====== ASSOCIATIONS =======
	has_one :contact_list, :foreign_key => :delayed_job_id
	
end

