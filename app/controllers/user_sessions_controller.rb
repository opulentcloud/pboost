class UserSessionsController < ApplicationController
	ssl_required :new, :create
	ssl_allowed :destroy
	
	def new
		@user_session = UserSession.new
	end
	
	def create
		@user_session = UserSession.new(params[:user_session])

		if @user_session.save
			if params[:user_session][:remember_me] == "1"
				#save users email for display upon return to login screen
				cookies[:login] = { :value => params[:user_session][:login], :expires => 6.months.from_now }
			else
				cookies.delete :login
			end
			route_initial_login @user_session.login, root_url
		else
			render :action => :new
		end
	end
	
	def destroy
		current_user_session.destroy
		flash[:notice] = 'You have been Logged out.'
		redirect_back_or_default login_url
	end
	
end
