# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(create_params)

        if user.save
          render json: {
            messages: I18n.t('auth.signup_successfully'),
            data: { user: user }
          }, status: :ok
        else
          render json: {
            message: 'Unable to create user',
            errors: user.errors.full_messages
          }, status: :bad_request
        end
      end

      private

      def create_params
        params.permit(:username, :password, :password_confirmation)
      end
    end
  end
end
