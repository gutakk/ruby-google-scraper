# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #home' do
      expect(get: '/').to route_to('application#home')
    end
  end
end
