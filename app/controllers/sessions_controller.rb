# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'auth', only: %i[new create]

  before_action :redirect_to_home, only: :new

  def new; end

  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session[:user_id] = user[:id]

      redirect_to root_path
    else
      flash.now[:alert] = t('auth.login_failed')

      render :new
    end
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_url, notice: t('auth.logout_successfully')
  end
end
