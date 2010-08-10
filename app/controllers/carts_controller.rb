class CartsController < ApplicationController
	before_filter :require_user
	filter_access_to :all

	def show
		@cart = current_cart
	end
end
