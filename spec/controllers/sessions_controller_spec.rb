# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET#new' do
    it 'returns a successful response' do
      get :new

      expect(response).to be_successful
    end

    it 'renders a correct template' do
      get :new

      expect(response).to render_template(:new)
    end

    it 'redirects to home when session exists' do
      user = Fabricate(:user, username: 'nimblehq', password: 'password', password_confirmation: 'password')
      session[:user_id] = user[:id]

      get :new

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'POST#create' do
    context 'given invalid parameters' do
      it 'creates user id session and redirects to home page' do
        user = Fabricate(:user, username: 'nimblehq', password: 'password', password_confirmation: 'password')

        post :create, params: { username: user[:username], password: 'password' }

        expect(session[:user_id]).to eql(user[:id])
        expect(response).to redirect_to(root_path)
      end
    end

    context 'given invalid parameters' do
      context 'given an invalid username' do
        it 'does NOT set user_id to session' do
          Fabricate(:user)

          post :create, params: { username: 'qhelbmin', password: 'password' }

          expect(session).to be_empty
        end

        it 'shows an alert flash' do
          Fabricate(:user)

          post :create, params: { username: 'qhelbmin', password: 'password' }

          expect(flash[:alert]).to eql(I18n.t('auth.login_failed'))
        end

        it 'renders the template of :new action' do
          Fabricate(:user)

          post :create, params: { username: 'qhelbmin', password: 'password' }

          expect(response).to render_template(:new)
        end
      end

      context 'given an invalid password' do
        it 'does NOT set user_id to session' do
          Fabricate(:user)

          post :create, params: { username: 'nimblehq', password: 'drowssap' }

          expect(session).to be_empty
        end

        it 'shows an alert flash' do
          Fabricate(:user)

          post :create, params: { username: 'qhelbmin', password: 'drowssap' }

          expect(flash[:alert]).to eql(I18n.t('auth.login_failed'))
        end

        it 'renders the template of :new action' do
          Fabricate(:user)

          post :create, params: { username: 'qhelbmin', password: 'drowssap' }

          expect(response).to render_template(:new)
        end
      end
    end
  end
end
