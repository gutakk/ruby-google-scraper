# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ActionController::API
      include Localization
      include Api::V1::ResponseHandler

      def doorkeeper_unauthorized_render_options(error: nil)
        { json: error }
      end
    end
  end
end
