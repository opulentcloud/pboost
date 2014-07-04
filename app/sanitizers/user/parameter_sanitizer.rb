class User::ParameterSanitizer < Devise::ParameterSanitizer
  def sign_in
    default_params.permit(:email, :password)
  end
  
  def sign_up
    default_params.permit({ roles: [] }, :role, :first_name, :last_name, 
      :email, :password, :password_confirmation)  
  end
end
