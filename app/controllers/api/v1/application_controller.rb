# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include Localization
      include Api::V1::ErrorHandler

      private

      def doorkeeper_unauthorized_render_options(error: nil)
        return unless error

        {
          json: {
            errors: build_errors(detail: error.description, source: error.state, code: error.name)
          }
        }
      end
    end
  end
end
