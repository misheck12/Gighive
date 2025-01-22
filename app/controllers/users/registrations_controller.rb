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

  # POST /users/create_freelancer
  def create_freelancer
    if User.exists?(email: sign_up_params[:email])
      flash.now[:alert] = "Email has already been taken."
      build_resource(sign_up_params)
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    else
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
  end

  protected

  # Permit additional parameters for sign up
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :name, :photo, :email, :password, :password_confirmation, :terms_of_service
    ])
  end

  # Permit additional parameters for account update
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :photo])
  end

  private

  # Ensure that only admin users can access certain actions
  def ensure_admin
    redirect_to root_path, alert: 'You are not authorized to perform this action.' unless current_user&.admin?
  end
end