class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :require_admin_user!, :only => [:new, :create, :destroy]
end
