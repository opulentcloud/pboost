class User < ActiveRecord::Base
	#===== authlogic config ======
	acts_as_authentic do |c| #AuthLogic base
		c.validates_length_of_password_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
		c.validates_length_of_password_confirmation_field_options = {:on => :update, :minimum => 4, :if => :has_no_credentials?}
		c.logged_in_timeout = 90.minutes
	end

	#===== METHODS =====
	def has_no_credentials?
		self.crypted_password.blank?
	end

end
