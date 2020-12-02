# frozen_string_literal: true

module Api
  module V1
    class TokensController < Doorkeeper::TokensController
      include Api::V1::ErrorHandler

      private

      def revocation_error_response
        {
          errors: build_errors(
            detail: I18n.t('doorkeeper.errors.messages.revoke.unauthorized'),
            code: :unauthorized_client
          )
        }
      end
    end
  end
end
