# frozen_string_literal: true

module Api
  module V1
    module ResponseHandler
      extend ActiveSupport::Concern

      private

      # Render successful response in json format
      def render_successful_response(messages, status, data: nil)
        response_body = { messages: messages }
        response_body[:data] = data if data.present?

        render json: response_body, status: status
      end

      # Render error response in json format
      def render_error_response(messages, status, reasons: nil)
        response_body = { messages: messages }
        response_body[:reasons] = reasons if reasons.present?

        render json: response_body, status: status
      end
    end
  end
end
