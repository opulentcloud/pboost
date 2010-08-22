class CustomerController < ApplicationController
	before_filter :require_user
	filter_access_to :all
	ssl_required :index
	
	def index
	end

end
