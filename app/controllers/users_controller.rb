# frozen_string_literal: true

class UsersController < ApplicationController
  layout 'auth', only: %i[new create]

  before_action :require_no_authentication, only: %i[new create]

  def new
    render locals: {
      user: User.new
    }
  end

  def create
    user = User.new(create_params)

    if user.save
      redirect_to login_path, notice: t('auth.signup_successfully')
    else
      render :new, locals: {
        user: user
      }
    end
  end

  private

  def create_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
