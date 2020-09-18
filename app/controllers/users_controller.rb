# frozen_string_literal: true

class UsersController < ApplicationController
  # GET /users
  def index
    @users = User.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to action: 'index', notice: 'User was successfully created.'
    else
      render :new
    end
  end

  private

  # Only allow a trusted parameter "white list" through.
  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
