# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Localization

  helper_method :current_user

  private

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    redirect_to root_path if current_user
  end
end
