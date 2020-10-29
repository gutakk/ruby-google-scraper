# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include Localization
      include Api::V1::ResponseHandler

      private

      def doorkeeper_unauthorized_render_options(error: nil)
        {
          json: {
            messages: I18n.t('doorkeeper.errors.messages.unauthorized_client'),
            reasons: error.description
          }
        }
      end
    end
  end
end
