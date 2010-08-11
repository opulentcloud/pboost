class LineItemsController < ApplicationController
	before_filter :require_user
	filter_access_to :all

	def create
		@product => Product.find(params[:product_id])
		@contact_list = current_user.organization.contact_lists.find(params[:contact_list_id]) unless params[:contact_list_id].nil?
		@campaign = current_user.organization.campaigns.find(params[:campaign_id]) unless params[:campaign_id].nil?

		@line_item = LineItem.create_line_item!(current_cart, @product,  @contact_list, @campaign, qty, @product_price)

		flash[:notice] = "Added #{@product.name} to cart."
		redirect_to current_cart_url
	end

end
