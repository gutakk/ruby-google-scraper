# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Localization

  helper_method :logged_in?, :current_user

  private

  def logged_in?
    session[:user_id].present?
  end

  def current_user
    return unless logged_in?

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def redirect_to_home
    redirect_to root_path
  end

  def require_redirection?
    case action_name
    when 'new'
      return true if logged_in?
    when 'create'
      return true if logged_in?
    when 'destroy'
      return true unless logged_in?
    end
  end
end
