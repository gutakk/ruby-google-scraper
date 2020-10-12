# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsController, type: :routing do
  describe 'routing' do
    it { expect(get: '/keywords').to route_to('keywords#index') }

    it { expect(get: '/keywords/1234').to route_to('keywords#show', id: '1234') }

    it { expect(post: '/keywords').to route_to('keywords#create') }
  end
end
