# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::KeywordsController, type: :routing do
  describe 'routing' do
    it { expect(get: 'api/v1/keywords').to route_to('api/v1/keywords#index') }

    it { expect(get: 'api/v1/keywords/1234').to route_to('api/v1/keywords#show', id: '1234') }

    it { expect(post: 'api/v1/keywords').to route_to('api/v1/keywords#create') }
  end
end
