class Admin::UsersController < Devise::RegistrationsController
  skip_before_filter :require_no_authentication
  before_filter :require_admin_user!
  
  def index
    @users = User.all
  end
  
  def new
    build_resource({})
    resource.roles.build
    render "admin/users/new"
  end

  def create
    build_resource(account_update_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      redirect_to admin_users_path, notice: "User created successfully."
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  def edit
    self.resource = User.find(params[:id].to_i)
  end
  
  def update
  # required for settings form to submit when password is left blank
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
      account_update_params.delete("current_password")
    end     

    self.resource = User.find(params[:id].to_i)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = resource.update_attributes(account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      redirect_to admin_users_path and return
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
  
  def destroy
    @user = User.find(params[:id].to_i)
    if @user.destroy
      redirect_to admin_users_path, notice: "User deleted successfully."
    else
      flash[:error] = "This user can not be deleted - it's the only admin user in the system."
      redirect_to admin_users_path
    end
  end
  
private
  def account_update_params
    @account_update_params ||= params.require(:user).permit(:first_name, 
      :last_name, :email, :password, :password_confirmation, 
      :current_password, role_ids: [], roles_attributes: :id)
    
  end
end
