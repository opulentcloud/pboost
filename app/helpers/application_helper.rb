# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def which_control_panel()
		return admin_control_panel_url if current_user && current_user.is_admin?
		return customer_control_panel_url if current_user
					
#		return case current_controller
#			when 'admin' then admin_control_panel_url
#			when 'campaigns' then customer_control_panel_url
#			when 'customer' then customer_control_panel_url
#			when 'gis_regions' then customer_control_panel_url
#			when 'phone_bank_lists' then customer_control_panel_url
#			when 'robocall_campaigns' then customer_control_panel_url
#			when 'robocall_lists' then customer_control_panel_url
#			when 'sms_campaigns' then customer_control_panel_url
#			when 'sms_lists' then customer_control_panel_url
#			when 'surveys' then admin_control_panel_url
#			when 'survey_results' then customer_control_panel_url
#			when 'walksheets' then customer_control_panel_url
#		end
	end

	def li_navigation_tag(controller, action)

		r = '<li>'
		controller.split('|').each do |c|
			begin
				if current_page?(:controller => c, :action => action)
					r = '<li class="active">'
				end
			rescue
			end
		end		
		r
	end

	def format_date(date_time)
		date_time.strftime '%m/%d/%Y' rescue nil
	end

	def format_date_time(date_time)
		date_time.strftime '%m/%d/%Y %I:%M %p %Z' rescue nil
	end

	def time_format(time)
		time.strftime '%I:%M %p %Z' rescue nil
	end

	def format_phone_number(phone_record)
		return String.empty unless !phone_record.nil?
		number_to_phone(phone_record, :area_code => false, :extension => nil)
	end

end
