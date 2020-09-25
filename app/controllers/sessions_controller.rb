# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'auth', only: :new
  before_action :redirect_to_home?

  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      redirect_to root_path
    else
      flash.now[:alert] = t('auth.login_failed')

      render :new
    end
  end
end
