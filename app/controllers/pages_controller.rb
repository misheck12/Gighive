class PagesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:about_us, :working_with_us, :contact_us, :privacy, :terms]

  def about_us
  end

  def working_with_us
  end

  def contact_us
    
  end

  def privacy
    # Logic for Privacy Policy page (if any)
  end

  # New action for Terms of Service
  def terms
    # Logic for Terms of Service page (if any)
  end
end
