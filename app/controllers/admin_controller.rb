class AdminController < ApplicationController
	before_filter :require_user
	filter_access_to :all
	
	def index
	end

end
