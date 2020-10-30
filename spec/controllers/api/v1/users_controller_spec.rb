# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'POST#create' do
    context 'given valid parameters' do
      it 'creates a new user' do
        expect do
          post :create, params: { username: 'nimblehq', password: 'password', password_confirmation: 'password' }
        end.to change(User, :count).by(1)
      end

      it 'returns created status' do
        post :create, params: { username: 'nimblehq', password: 'password', password_confirmation: 'password' }

        expect(response).to have_http_status(:created)
      end

      it 'returns JSON API response body' do
        post :create, params: { username: 'nimblehq', password: 'password', password_confirmation: 'password' }

        response_body = JSON.parse(response.body)

        expect(response_body['data']['type']).to eql('user')
        expect(response_body['data']['attributes']['username']).to eql('nimblehq')
      end
    end

    context 'given invalid parameters' do
      it 'does NOT create a new user when username is nil' do
        expect do
          post :create, params: { username: nil, password: 'password', password_confirmation: 'password' }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when username is empty string' do
        expect do
          post :create, params: { username: '', password: 'password', password_confirmation: 'password' }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when password and password confirmation are NOT match' do
        expect do
          post :create, params: { username: 'nimblehq', password: 'password', password_confirmation: 'drowssap' }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when password is nil' do
        expect do
          post :create, params: { username: 'nimblehq', password: nil, password_confirmation: 'password' }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when password is empty string' do
        expect do
          post :create, params: { username: 'nimblehq', password: '', password_confirmation: 'password' }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when password confirmation is nil' do
        expect do
          post :create, params: { username: 'nimblehq', password: 'password', password_confirmation: nil }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when password confirmation is empty string' do
        expect do
          post :create, params: { username: 'nimblehq', password: 'password', password_confirmation: '' }
        end.to change(User, :count).by(0)
      end

      it 'returns bad request status' do
        post :create, params: { username: nil, password: nil, password_confirmation: nil }

        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error response body' do
        post :create, params: { username: nil, password: nil, password_confirmation: nil }

        response_body = JSON.parse(response.body)

        expect(response_body['errors'][0]['detail']).to include("Password #{I18n.t('activerecord.errors.models.user.blank')}")
        expect(response_body['errors'][0]['detail']).to include("Password confirmation #{I18n.t('activerecord.errors.models.user.blank')}")
        expect(response_body['errors'][0]['detail']).to include("Username #{I18n.t('activerecord.errors.models.user.blank')}")
        expect(response_body['errors'][0]['detail']).to include("Password #{I18n.t('activerecord.errors.models.user.attributes.password.too_short', count: 6)}")
      end
    end
  end
end
