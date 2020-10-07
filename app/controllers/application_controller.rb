# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Localization

  helper_method :authenticated?, :current_user

  private

  def authenticated?
    session[:user_id].present?
  end

  def current_user
    return unless authenticated?

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def ensure_no_authentication
    redirect_to root_path if authenticated?
  end

  def ensure_autentication
    redirect_to login_path unless authenticated?
  end
end
