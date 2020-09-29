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

  def ensure_authentication
    redirect_to login_path unless authenticated?
  end

  def require_login
    redirect_to login_path, alert: t('auth.require_login', page: t('keyword.page')) unless current_user
  end
end
