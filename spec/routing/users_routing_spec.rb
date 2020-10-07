# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it { expect(get: '/signup').to route_to('users#new') }

    it { expect(post: '/signup').to route_to('users#create') }
  end
end
