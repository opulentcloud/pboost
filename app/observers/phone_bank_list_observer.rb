class PhoneBankListObserver < ActiveRecord::Observer

	@@delayed_job = RAILS_ENV == 'production'

	def after_create(phone_bank_list)
		if @@delayed_job == true
			Delayed::Job.enqueue PhoneBankListJob.new(phone_bank_list.id)
		else
			Delayed::Job.enqueue PhoneBankListJob.new(phone_bank_list.id)
			#phone_bank_list.populate
		end
	end	

	def after_update(phone_bank_list)
		return true unless phone_bank_list.repopulate == true
		#if @@delayed_job == true
			Delayed::Job.enqueue PhoneBankListJob.new(phone_bank_list.id)
		#else
		#	phone_bank_list.populate
		#end
	end	

end

