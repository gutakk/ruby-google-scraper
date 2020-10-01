# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET#new' do
    context 'given NO user_id session' do
      it 'returns a successful response' do
        get :new

        expect(response).to be_successful
      end

      it 'renders the template of :new action' do
        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'given the user_id session' do
      it 'redirects to home page' do
        user = Fabricate(:user)
        session[:user_id] = user.id

        get :new

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST#create' do
    context 'given the user_id session' do
      it 'redirects to home page' do
        user = Fabricate(:user)
        session[:user_id] = user.id

        post :create, params: { user: { username: 'nimblehq', password: 'password', password_confirmation: 'password' } }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'given valid parameters' do
      it 'creates a new user' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: 'password', password_confirmation: 'password' } }
        end.to change(User, :count).by(1)
      end

      it 'redirects to login' do
        post :create, params: { user: { username: 'nimblehq', password: 'password', password_confirmation: 'password' } }

        expect(response).to redirect_to(login_path)
      end
    end

    context 'given invalid parameters' do
      it 'does NOT create a new user when username is nil' do
        expect do
          post :create, params: { user: { username: nil, password: 'password', password_confirmation: 'password' } }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when username is empty string' do
        expect do
          post :create, params: { user: { username: '', password: 'password', password_confirmation: 'password' } }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when password and password confirmation are NOT match' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: 'password', password_confirmation: 'drowssap' } }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when password is nil' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: nil, password_confirmation: 'password' } }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when password is empty string' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: '', password_confirmation: 'password' } }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when password confirmation is nil' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: 'password', password_confirmation: nil } }
        end.to change(User, :count).by(0)
      end

      it 'does NOT create a new user when password confirmation is empty string' do
        expect do
          post :create, params: { user: { username: 'nimblehq', password: 'password', password_confirmation: '' } }
        end.to change(User, :count).by(0)
      end

      it 'renders a successful response' do
        post :create, params: { user: { username: nil, password: nil, password_confirmation: nil } }

        expect(response).to be_successful
      end

      it 'renders the template of :new action' do
        post :create, params: { user: { username: nil, password: nil, password_confirmation: nil } }

        expect(response).to render_template(:new)
      end
    end
  end
end
