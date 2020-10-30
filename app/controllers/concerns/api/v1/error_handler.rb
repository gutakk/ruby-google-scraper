# frozen_string_literal: true

module Api
  module V1
    module ErrorHandler
      extend ActiveSupport::Concern

      private

      # Render error response in json format
      def render_error_response(detail:, source: nil, meta: nil, status: :unprocessable_entity, code: nil)
        errors = build_errors(detail: detail, source: source, meta: meta, code: code)

        render json: { errors: errors }, status: status
      end

      def build_errors(detail:, source: nil, meta: nil, code: nil)
        [
          {
            source: source,
            detail: detail,
            code: code,
            meta: meta
          }.compact
        ]
      end
    end
  end
end
