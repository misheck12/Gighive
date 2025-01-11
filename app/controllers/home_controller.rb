class HomeController < ApplicationController
  # Skip authentication for the index action to allow public access to the landing page
  skip_before_action :authenticate_user!, only: [:index]
  
  # Redirect logged-in users away from the home page
  before_action :redirect_if_logged_in, only: [:index]

  def index
    # Any additional logic for the landing page can be added here
  end

  private

  def redirect_if_logged_in
    if user_signed_in?
      redirect_to dashboard_path, notice: "You are already signed in."
    end
  end
end