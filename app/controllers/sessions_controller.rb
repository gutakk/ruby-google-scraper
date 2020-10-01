# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'auth', only: %i[new create]

  before_action :redirect_to_home, if: :current_user, only: %i[new create]

  def new; end

  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session[:user_id] = user[:id]

      redirect_to_home
    else
      flash.now[:alert] = t('auth.login_failed')

      render :new
    end
  end
end
