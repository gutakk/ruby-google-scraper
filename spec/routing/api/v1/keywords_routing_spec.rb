# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::KeywordsController, type: :routing do
  describe 'routing' do
    it 'gets /api/v1/keywords to api v1 keywords controller, index action' do
      expect(get: 'api/v1/keywords').to route_to('api/v1/keywords#index')
    end

    it 'gets /api/v1/keywords/<id> to api v1 keywords controller, show action' do
      expect(get: 'api/v1/keywords/1234').to route_to('api/v1/keywords#show', id: '1234')
    end

    it 'post /api/v1/keywords to api v1 keywords controller, create action' do
      expect(post: 'api/v1/keywords').to route_to('api/v1/keywords#create')
    end
  end
end
