# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
	include SslRequirement

	alias :original_ssl_required? :ssl_required?
	def ssl_required?
		if RAILS_ENV == 'development'
			false
		else
			original_ssl_required?
		end
	end

  helper :all # include all helpers, all the time
	helper_method :current_user, :current_user_session, :redirect_back_or_default, :current_controller, :current_political_campaign
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

	before_filter { |c| Authorization.current_user = c.current_user }
	before_filter :set_timezone

	def permission_denied
		flash[:error] = 'You do not have permission to access this page.'
		redirect_back_or_default login_url
	end

	def redirect_to_back
		request.env["HTTP_REFERER"] ||= root_url
		redirect_to :back
	end

  def current_user
  	return @current_user if defined?(@current_user)
  	@current_user = current_user_session && current_user_session.record
  	return @current_user
	end

private

	def current_controller
		return params[:controller]
	end

	def require_user
		unless current_user
			store_location
			flash[:notice] = 'You must be logged in to access this page.'
			redirect_to login_url
			return false
		end	
	end

	def set_timezone
		Time.zone = "Eastern Time (US & Canada)"

		if current_user
			Time.zone = current_user.time_zone.zone rescue nil
		end
	end

	def store_location
		session[:return_to] = request.request_uri
	end
	
	def redirect_back_or_default(default)
		current_url = session[:return_to] ||= default
		session[:return_to] = nil
		redirect_to(current_url)
	end

	def current_political_campaign
		if current_user
			session[:current_political_campaign] ||= current_user.political_campaigns.first.id rescue nil
			begin
				PoliticalCampaign.find(session[:current_political_campaign])
			rescue ActiveRecord::RecordNotFound
				nil
			end
		end
	end

	def route_initial_login(login, default)
		retval = default
		@user = User.find_by_login(login)
		#save users name for display upon return to login screen
		cookies[:first_name] = { :value => ", #{@user.first_name}", :expires => 6.months.from_now }

		if @user.roles.map(&:name).include?('Administrator')
			retval = admin_control_panel_url
		elsif @user.roles.map(&:name).include?('Customer')
			retval = customer_control_panel_url
		end

		redirect_back_or_default retval
	end

  def current_user_session
  	return @current_user_session if defined?(@current_user_session)
  	@current_user_session = UserSession.find
  end	

end
