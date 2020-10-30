# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(create_params)

        if user.save
          render json: UserSerializer.new(user).serializable_hash, status: :created
        else
          render_error_response(
            I18n.t('auth.signup_unsuccessfully'),
            :bad_request,
            reasons: user.errors.full_messages
          )
        end
      end

      private

      def create_params
        params.permit(:username, :password, :password_confirmation)
      end
    end
  end
end
