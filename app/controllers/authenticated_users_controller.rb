class AuthenticatedUsersController < ApplicationController
  before_action :authenticate_user!

end

