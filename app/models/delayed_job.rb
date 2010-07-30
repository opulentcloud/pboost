class DelayedJob < ActiveRecord::Base
	#====== ASSOCIATIONS =======
	has_one :contact_list
	
end

