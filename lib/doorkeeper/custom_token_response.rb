# frozen_string_literal: true

module Doorkeeper
  module CustomTokenResponse
    def body
      {
        data: {
          id: @token.id,
          type: 'token',
          attributes: super
        }
      }
    end
  end
end
