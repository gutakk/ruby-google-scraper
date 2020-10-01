# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsController, type: :controller do
  describe 'GET#new' do
    context 'given the user_id session' do
      it 'returns a successful response' do
        user = Fabricate(:user)
        session[:user_id] = user[:id]

        get :new

        expect(response).to be_successful
      end

      it 'renders the template of :new action' do
        user = Fabricate(:user)
        session[:user_id] = user[:id]

        get :new

        expect(response).to render_template(:new)
      end
    end

    context 'given NO user_id session' do
      it 'redirects to login' do
        get :new

        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'POST#create' do
    context 'given valid parameters (file)' do
      it 'inserts keywords to database' do
        user = Fabricate(:user)
        session[:user_id] = user[:id]
        file = fixture_file_upload('files/example.csv', 'text/csv')

        expect do
          post :create, params: { keyword: { file: file } }
        end.to change(Keyword, :count).by(6)
      end

      it 'redirects to keywords path' do
        user = Fabricate(:user)
        session[:user_id] = user[:id]
        file = fixture_file_upload('files/example.csv', 'text/csv')

        post :create, params: { keyword: { file: file } }

        expect(response).to redirect_to(keywords_path)
      end

      it 'shows a notice flash' do
        user = Fabricate(:user)
        session[:user_id] = user[:id]
        file = fixture_file_upload('files/example.csv', 'text/csv')

        post :create, params: { keyword: { file: file } }

        expect(flash[:notice]).to eql(I18n.t('keyword.upload_csv_successfully'))
      end
    end

    context 'given invalid parameters (file)' do
      context 'given invalid file type' do
        it 'redirects to keywords path' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]
          file = fixture_file_upload('files/nimble.png')

          post :create, params: { keyword: { file: file } }

          expect(response).to redirect_to(keywords_path)
        end

        it 'shows an alert flash' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]
          file = fixture_file_upload('files/nimble.png')

          post :create, params: { keyword: { file: file } }

          expect(flash[:alert]).to eql(I18n.t('keyword.file_must_be_csv'))
        end
      end

      context 'given no keyword csv' do
        it 'redirects to keywords path' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]
          file = fixture_file_upload('files/no_keywords.csv', 'text/csv')

          post :create, params: { keyword: { file: file } }

          expect(response).to redirect_to(keywords_path)
        end

        it 'shows an alert flash' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]
          file = fixture_file_upload('files/no_keywords.csv', 'text/csv')

          post :create, params: { keyword: { file: file } }

          expect(flash[:alert]).to eql(I18n.t('keyword.keyword_range'))
        end
      end

      context 'given more than 1,000 keywords csv' do
        it 'redirects to keywords path' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]
          file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')

          post :create, params: { keyword: { file: file } }

          expect(response).to redirect_to(keywords_path)
        end

        it 'shows an alert flash' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]
          file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')

          post :create, params: { keyword: { file: file } }

          expect(flash[:alert]).to eql(I18n.t('keyword.keyword_range'))
        end
      end
    end
  end
end
