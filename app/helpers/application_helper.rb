# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def li_navigation_tag(controller, action)

		r = '<li>'
		begin
			if current_page?(:controller => controller, :action => action)
				r = '<li class="active">'
			end
		rescue
		end
		r
	end

end
