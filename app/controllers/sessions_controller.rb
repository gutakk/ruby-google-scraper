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
      flash.now[:alert] = t('auth.username_or_password_is_invalid')

      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:return_to)

    flash[:notice] = t('auth.logout_successfully')

    redirect_to root_path
  end
end
