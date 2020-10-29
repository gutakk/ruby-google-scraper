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

      it 'renders created status' do
        post :create, params: { username: 'nimblehq', password: 'password', password_confirmation: 'password' }

        expect(response).to have_http_status(:created)
      end

      it 'renders successful response body' do
        post :create, params: { username: 'nimblehq', password: 'password', password_confirmation: 'password' }

        expect(JSON.parse(response.body)['message']).to eql(I18n.t('auth.signup_successfully'))
        expect(JSON.parse(response.body)['data']['username']).to eql('nimblehq')
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

      it 'renders bad request status' do
        post :create, params: { username: nil, password: nil, password_confirmation: nil }

        expect(response).to have_http_status(:bad_request)
      end

      it 'renders error response body' do
        post :create, params: { username: nil, password: nil, password_confirmation: nil }

        expect(JSON.parse(response.body)['message']).to eql(I18n.t('auth.signup_unsuccessfully'))
        expect(JSON.parse(response.body)['errors']).to include("Password #{I18n.t('activerecord.errors.models.user.blank')}")
        expect(JSON.parse(response.body)['errors']).to include("Password confirmation #{I18n.t('activerecord.errors.models.user.blank')}")
        expect(JSON.parse(response.body)['errors']).to include("Username #{I18n.t('activerecord.errors.models.user.blank')}")
        expect(JSON.parse(response.body)['errors']).to include("Password #{I18n.t('activerecord.errors.models.user.attributes.password.too_short', count: 6)}")
      end
    end
  end
end
