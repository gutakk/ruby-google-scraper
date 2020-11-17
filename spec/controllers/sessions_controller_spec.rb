# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
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

        post :create, params: { username: user.username, password: 'password' }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'given valid parameters' do
      it 'creates user id session' do
        user = Fabricate(:user)

        post :create, params: { username: user.username, password: 'password' }

        expect(session[:user_id]).to eql(user.id)
      end

      it 'redirects to home page' do
        user = Fabricate(:user)

        post :create, params: { username: user.username, password: 'password' }

        expect(response).to redirect_to(root_path)
      end
    end

    context 'given return_to path' do
      it 'returns to new keywords path when return_to path is keywords' do
        user = Fabricate(:user)
        session[:return_to] = keywords_path

        post :create, params: { username: user.username, password: 'password' }

        expect(response).to redirect_to(keywords_path)
      end

      it 'deletes return_to session' do
        user = Fabricate(:user)
        session[:return_to] = keywords_path

        post :create, params: { username: user.username, password: 'password' }

        expect(session[:return_to]).to be_nil
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

          expect(flash[:alert]).to eql(I18n.t('auth.username_or_password_is_invalid'))
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

          post :create, params: { username: 'nimblehq', password: 'drowssap' }

          expect(flash[:alert]).to eql(I18n.t('auth.username_or_password_is_invalid'))
        end

        it 'renders the template of :new action' do
          Fabricate(:user)

          post :create, params: { username: 'nimblehq', password: 'drowssap' }

          expect(response).to render_template(:new)
        end
      end

      context 'given both invalid username and password' do
        it 'does NOT set user_id to session' do
          Fabricate(:user)

          post :create, params: { username: 'qhelbmin', password: 'drowssap' }

          expect(session).to be_empty
        end

        it 'shows an alert flash' do
          Fabricate(:user)

          post :create, params: { username: 'qhelbmin', password: 'drowssap' }

          expect(flash[:alert]).to eql(I18n.t('auth.username_or_password_is_invalid'))
        end

        it 'renders the template of :new action' do
          Fabricate(:user)

          post :create, params: { username: 'qhelbmin', password: 'drowssap' }

          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe 'DELETE#destroy' do
    context 'given authenticated user' do
      it 'returns a redirect response' do
        session[:user_id] = 'test'

        delete :destroy

        expect(response).to be_redirect
      end

      it 'redirects to root path' do
        session[:user_id] = 'test'

        delete :destroy

        expect(response).to redirect_to(root_path)
      end

      it 'deletes the user_id session' do
        session[:user_id] = 'test'

        expect(session[:user_id]).to eql('test')

        delete :destroy

        expect(session[:user_id]).to be_nil
      end

      it 'deletes the return_to session' do
        session[:user_id] = 'test'

        delete :destroy

        expect(session[:return_to]).to be_nil
      end

      it 'shows notice flash message' do
        session[:user_id] = 'test'

        delete :destroy

        expect(flash[:notice]).to eql(I18n.t('auth.logout_successfully'))
      end
    end

    context 'given unauthenticated user' do
      it 'redirects to login_path' do
        delete :destroy

        expect(response).to redirect_to(login_path)
      end

      it 'does NOT show notice flash message' do
        delete :destroy

        expect(flash[:notice]).to be_nil
      end
    end
  end
end
