class HomeController < ApplicationController
  # Skip authentication for the index action to allow public access to the landing page
  skip_before_action :authenticate_user!, only: [:index]

  def index
    # Any additional logic for the landing page can be added here
  end
end