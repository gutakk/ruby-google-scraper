# frozen_string_literal: true

class UsersController < ApplicationController
  def new
    @user = User.new
    render layout: 'auth'
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, notice: t('auth.signed_up_successfully')
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
