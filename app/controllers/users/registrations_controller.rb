class Users::RegistrationsController < Devise::RegistrationsController

# begin protected class methods
protected

  def after_sign_up_path_for(resource)
    '/signin'
  end
  
  def after_inactive_sign_up_path_for(resource)
    '/signin'
  end
# end protected class methods  
end
