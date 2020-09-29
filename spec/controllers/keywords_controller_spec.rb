# frozen_string_literal: true

require 'rails_helper'

RSpec.describe KeywordsController, type: :controller do
  describe 'GET#new' do
    # Logged in required before access to keywords controller
    before(:each) do |test|
      if test.metadata[:logged_in]
        user = Fabricate(:user, username: 'nimblehq', password: 'password', password_confirmation: 'password')
        session[:user_id] = user[:id]
      end

      get :new
    end

    it 'renders a successful response', :logged_in do
      expect(response).to be_successful
    end

    it 'renders a correct template', :logged_in do
      expect(response).to render_template(:new)
    end

    it 'redirect to login when not login' do
      expect(response).to redirect_to(login_path)
    end
  end

  describe 'POST#create' do
    context 'with valid params' do
      it 'valid csv file' do
        user = Fabricate(:user, username: 'nimblehq', password: 'password', password_confirmation: 'password')
        session[:user_id] = user[:id]

        file = fixture_file_upload('files/example.csv', 'text/csv')

        expect do
          post :create, params: { keyword: { file: file } }
        end.to change(Keyword, :count).by(6)

        expect(response).to redirect_to(keywords_path)
        expect(flash[:notice]).to eql(I18n.t('keyword.upload_csv_successfully'))
      end
    end

    context 'with invalid params' do
      it 'not csv file' do
        file = fixture_file_upload('files/nimble.png')

        post :create, params: { keyword: { file: file } }

        expect(response).to redirect_to(keywords_path)
        expect(flash[:alert]).to eql(I18n.t('keyword.file_must_be_csv'))
      end

      it 'no keywords csv file' do
        file = fixture_file_upload('files/no_keywords.csv', 'text/csv')

        post :create, params: { keyword: { file: file } }

        expect(response).to redirect_to(keywords_path)
        expect(flash[:alert]).to eql(I18n.t('keyword.keyword_range'))
      end

      it 'more than 1,000 keywords csv file' do
        file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')

        post :create, params: { keyword: { file: file } }

        expect(response).to redirect_to(keywords_path)
        expect(flash[:alert]).to eql(I18n.t('keyword.keyword_range'))
      end
    end
  end
end
