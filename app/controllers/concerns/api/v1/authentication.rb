# frozen_string_literal: true

module Api
  module V1
    module Authentication
      extend ActiveSupport::Concern

      included do
        attr_reader :current_user

        before_action :doorkeeper_authorize!
        before_action :load_current_user

        private

        def load_current_user
          user_id = doorkeeper_token.resource_owner_id

          @current_user = user_id.present? ? User.find(doorkeeper_token.resource_owner_id) : nil
        end
      end
    end
  end
end
