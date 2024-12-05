# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # Before action to configure additional parameters for sign in
  before_action :configure_sign_in_params, only: [:create]

  # GET /users/sign_in
  def new
    super
  end

  # POST /users/sign_in
  def create
    super
  end

  # DELETE /users/sign_out
  def destroy
    super
  end
end
