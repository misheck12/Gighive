class PagesController < ApplicationController

  skip_before_action :authenticate_user!, only: [:about_us, :working_with_us]

  def about_us
  end

  def working_with_us
  end

  def contact_us
    
  end
end
