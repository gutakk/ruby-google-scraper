# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'auth'

  def new; end

  def create
    user = User.find_by(username: params[:username])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to users_path, notice: 'Logged in'
    else
      flash[:alert] = t('auth.logged_in_failed')
      render :new
    end
  end
end
