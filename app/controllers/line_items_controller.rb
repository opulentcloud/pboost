class LineItemsController < ApplicationController
	before_filter :require_user
	filter_access_to :all

	def create
		case params[:service]
			when 'campaign' then
				@campaign = current_user.organization.campaigns.find(params[:id])
			when 'contact_list' then
				@contact_list = current_user.organization.contact_lists.find(params[:id])
		else
			flash[:error] = 'Unknown Service type could not be added to Cart.'
			render
			return
		end

		@line_item = LineItem.create_line_item!(current_cart, nil,  @contact_list, @campaign, nil, nil)

		flash[:notice] = "Added #{@product.name} to cart."
		redirect_to current_cart_url
	end

end
