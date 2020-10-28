# frozen_string_literal: true

module Api
  module V1
    module ResponseHandler
      extend ActiveSupport::Concern

      private

      # Render successful response in json format
      def render_successful_response(message, status, data: nil)
        response_body = { message: message }

        response_body[:data] = data if data.present?

        render json: response_body, status: status
      end

      # Render error response in json format
      def render_error_response(message, errors, status)
        render json: { message: message, errors: errors }, status: status
      end
    end
  end
end
