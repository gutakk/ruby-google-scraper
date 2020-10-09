# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'auth', only: %i[new create]

  before_action :ensure_no_authentication, only: %i[new create]
  before_action :ensure_authentication, only: :destroy

  def new; end

  def create
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      redirect_to_target_or_default(root_path)
    else
      flash.now[:alert] = t('auth.login_failed')

      render :new
    end
  end

  def destroy
    session.clear

    flash[:notice] = t('auth.logout_successfully')

    redirect_to root_path
  end
end
