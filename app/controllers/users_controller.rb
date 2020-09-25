# frozen_string_literal: true

class UsersController < ApplicationController
  layout 'auth', only: %i[new create]

  before_action :redirect_to_home, only: :new

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to login_path, notice: t('auth.signup_successfully')
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
