class ValidateSignupController < ApplicationController
	ssl_allowed :update
	before_filter :get_step

	def validate_signup
#debugger

#		render :text => 'success'
#		return #testing
		if @step == 1
			validate_step_1()
		elsif @step == 2
			validate_step_2()
		end

	end

	def validate_step_2()
#debugger
		@user = User.new
		@user.attributes = params[:user]

		if @user.valid_for_attributes? 'first_name','last_name','phone_area_code', 'phone_prefix', 'phone_suffix','email','login','password','password_confirmation','time_zone_id'
			session[:sstep_2] = params
			visited_steps.push(2)
			render :text => 'success'
		else
			#render :text => @user.errors.each_full{ |msg| puts msg }
			flash.now[:error] = @user.errors.each_full { |m| puts "#{m}" }.join('<br />')
			respond_to do |format|
				format.html
				format.js
			end
		end
		
	end

	def validate_step_1()
	#debugger
		@organization = Organization.new
		@organization.attributes = params[:user][:organization_attributes]

		if @organization.valid_for_attributes? 'organization_type_id','name','email','phone_area_code', 'phone_prefix', 'phone_suffix','fax_area_code','fax_prefix','fax_suffix', 'website'
			session[:sstep_1] = params
			visited_steps.push(1)
			render :text => 'success'
		else
			#render :text => @organization.errors.each_full{ |msg| puts msg }
			flash.now[:error] = @organization.errors.each_full { |m| puts "#{m}" }.join('<br />')
			respond_to do |format|
				format.html
				format.js 
			end
		end
	
	end

	def visited_steps
		return session[:ssteps_visited] ||= []
	end

	def visited_steps=(the_steps)
		session[:ssteps_visited] = the_steps
	end

private

	def get_step
		@step = params[:step_id].to_i
	end

end
