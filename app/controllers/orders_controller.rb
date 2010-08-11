class OrdersController < ApplicationController
	before_filter :require_user
	filter_access_to :all

	def new
		@order = Order.new
	end
	
	def create
		@order = current_cart.build_order(params[:order])
		@order.ip_address = request.remote_ip
		if @order.save
			if @order.purchase
				render :action => 'success'
			else
				render :action => 'failure'
			end
		else
			render :action => 'new'
		end
	end
end
