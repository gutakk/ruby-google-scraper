# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET#index' do
    it 'renders a successful response' do
      get :index

      expect(response).to be_successful
    end
  end

  describe 'GET#new' do
    it 'renders a successful response' do
      get :new

      expect(response).to be_successful
    end
  end

  describe 'POST#create' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: 'password', password_confirmation: 'password' } }
        end.to change(User, :count).by(1)
      end

      it 'redirect to signup index' do
        post :create, params: { user: { username: 'nimblehq', password: 'password', password_confirmation: 'password' } }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user when username is nil' do
        expect do
          post :create, params: { user: { username: nil, password: 'password', password_confirmation: 'password' } }
        end.to change(User, :count).by(0)
      end

      it 'does not create a new user when username is empty string' do
        expect do
          post :create, params: { user: { username: '', password: 'password', password_confirmation: 'password' } }
        end.to change(User, :count).by(0)
      end

      it 'does not create a new user when password and password confirmation are not match' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: 'password', password_confirmation: 'drowssap' } }
        end.to change(User, :count).by(0)
      end

      it 'does not create a new user when password is nil' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: nil, password_confirmation: 'password' } }
        end.to change(User, :count).by(0)
      end

      it 'does not create a new user when password is empty string' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: '', password_confirmation: 'password' } }
        end.to change(User, :count).by(0)
      end

      it 'does not create a new user when password confirmation is nil' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: 'password', password_confirmation: nil } }
        end.to change(User, :count).by(0)
      end

      it 'does not create a new user when password confirmation is empty string' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: 'password', password_confirmation: '' } }
        end.to change(User, :count).by(0)
      end

      it 'renders a successful response' do
        post :create, params: { user: { username: nil, password: nil, password_confirmation: nil } }

        expect(response).to be_successful
      end
    end
  end
end
