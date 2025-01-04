class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create, :create_freelancer]
  before_action :configure_account_update_params, only: [:update]
  before_action :ensure_admin, only: [:new_freelancer, :create_freelancer]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  end

  # GET /users/new_freelancer
  def new_freelancer
    build_resource({})
    respond_with self.resource
  end

  def create_freelancer
    build_resource(sign_up_params.merge(role: :freelancer))
    resource.save
    yield resource if block_given?
    if resource.persisted?
      # Removed auto sign-in
      flash[:notice] = 'Freelancer created successfully.'
      respond_with resource, location: dashboard_path
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :photo, :email, :password, :password_confirmation])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :photo])
  end

  private

  def ensure_admin
    redirect_to root_path, alert: 'You are not authorized to perform this action.' unless current_user&.admin?
  end
end
