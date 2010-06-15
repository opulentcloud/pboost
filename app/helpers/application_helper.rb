# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def which_control_panel()
		return case current_controller
			when 'admin' then admin_control_panel_url
			when 'customer' then customer_control_panel_url
			when 'gis_regions' then customer_control_panel_url
			when 'walk_sheets' then customer_control_panel_url
		end
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

end
