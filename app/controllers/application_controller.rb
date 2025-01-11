class ApplicationController < ActionController::Base
rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
before_action :authenticate_user!

def after_sign_in_path_for(resource)
  dashboard_path
end

private

def user_not_authorized
  flash[:alert] = "You are not authorized to perform this action."
  redirect_to(request.referrer || root_path)
end

end
