authorization do
	role :administrator do
		has_permission_on [:admin], :to => [:index]
		has_permission_on [:users], :to => [:index, :show, :new, :create, :edit, :update, :destroy]
	end

	role :customer do
		has_permission_on :customer, :to => [:index]
	end
	
	role :guest do
		has_permission_on :member, :to => [:join, :register, :resend]
		has_permission_on :site, :to => [:unauthorized, :index, :show_page]
	end
	
end

