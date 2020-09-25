# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'GET#new' do
    it 'renders a successful response' do
      get :new

      expect(response).to be_successful
    end

    it 'renders a correct template' do
      get :new

      expect(response).to render_template(:new)
    end

    it 'redirect to home when session exist' do
      user = Fabricate(:user, username: 'nimblehq', password: 'password', password_confirmation: 'password')
      session[:user_id] = user[:id]

      get :new

      expect(response).to redirect_to(root_path)
    end
  end

  describe 'POST#create' do
    context 'with valid parameters' do
      it 'username and password are valid' do
        user = Fabricate(:user, username: 'nimblehq', password: 'password', password_confirmation: 'password')

        post :create, params: { username: user[:username], password: 'password' }

        expect(session[:user_id]).to eql(user[:id])
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid parameters' do
      before(:each) do
        Fabricate(:user, username: 'nimblehq', password: 'password', password_confirmation: 'password')
      end

      # Every test cases expect the same thing
      after(:each) do
        expect(session).to be_empty
        expect(flash[:alert]).to eql(I18n.t('auth.login_failed'))
        expect(response).to render_template(:new)
      end

      it 'username is invalid' do
        post :create, params: { username: 'qhelbmin', password: 'password' }
      end

      it 'password in invalid' do
        post :create, params: { username: 'nimblehq', password: 'dorwssap' }
      end

      it 'both username and password are invalid' do
        post :create, params: { username: 'qhelbmin', password: 'dorwssap' }
      end
    end
  end
end
