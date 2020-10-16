# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe KeywordsController, type: :controller do
  ActiveJob::Base.queue_adapter = :test

  describe 'GET#index' do
    context 'given authenticated user' do
      it 'returns a successful response' do
        user = Fabricate(:user)
        session[:user_id] = user[:id]

        get :index

        expect(response).to be_successful
      end

      it 'renders the template of :index action' do
        user = Fabricate(:user)
        session[:user_id] = user[:id]

        get :index

        expect(response).to render_template(:index)
      end
    end

    context 'given unauthenticated user' do
      it 'redirects to login' do
        get :index

        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'GET#show' do
    context 'given the authenticated user' do
      context 'given correct keyword id' do
        it 'returns a successful response' do
          user = Fabricate(:user)
          keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'test')
          session[:user_id] = user[:id]

          get :show, params: { id: keyword[:id] }

          expect(response).to be_successful
        end

        it 'renders the template of :show action' do
          user = Fabricate(:user)
          keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'test')
          session[:user_id] = user[:id]

          get :show, params: { id: keyword[:id] }

          expect(response).to render_template(:show)
        end
      end

      context 'given incorrect keyword id' do
        it 'returns not found response' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]

          get :show, params: { id: 'not_found_id' }

          expect(response).to be_not_found
        end

        it 'renders not found template' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]

          get :show, params: { id: 'not_found_id' }

          expect(response).to render_template(:not_found)
        end
      end
    end

    context 'given unauthenticated user' do
      it 'redirects to login' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user[:id], keyword: 'test')

        get :show, params: { id: keyword[:id] }

        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe 'POST#create' do
    context 'given authenticated user' do
      context 'given valid parameters (file)' do
        it 'inserts keywords to database' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]
          file = fixture_file_upload('files/example.csv', 'text/csv')

          expect do
            post :create, params: { csv_import_form: { file: file } }
          end.to change(Keyword, :count).by(6)
        end

        it 'redirects to keywords path' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]
          file = fixture_file_upload('files/example.csv', 'text/csv')

          post :create, params: { csv_import_form: { file: file } }

          expect(response).to redirect_to(keywords_path)
        end

        it 'shows a notice flash' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]
          file = fixture_file_upload('files/example.csv', 'text/csv')

          post :create, params: { csv_import_form: { file: file } }

          expect(flash[:notice]).to eql(I18n.t('keyword.upload_csv_successfully'))
        end

        it 'creates google scraping worker sidekiq job' do
          user = Fabricate(:user)
          session[:user_id] = user[:id]
          file = fixture_file_upload('files/example.csv', 'text/csv')

          expect do
            post :create, params: { csv_import_form: { file: file } }
          end.to have_enqueued_job(GoogleScrapingJobManagementJob)
        end
      end

      context 'given invalid parameters (file)' do
        context 'given invalid file type' do
          it 'redirects to keywords path' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/nimble.png')

            post :create, params: { csv_import_form: { file: file } }

            expect(response).to redirect_to(keywords_path)
          end

          it 'shows an alert flash' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/nimble.png')

            post :create, params: { csv_import_form: { file: file } }

            expect(flash[:alert]).to eql(I18n.t('keyword.file_must_be_csv'))
          end

          it 'does NOT insert keywords to database' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/nimble.png')

            expect do
              post :create, params: { csv_import_form: { file: file } }
            end.to change(Keyword, :count).by(0)
          end

          it 'does NOT create google scraping worker sidekiq job' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/nimble.png')

            expect do
              post :create, params: { csv_import_form: { file: file } }
            end.not_to have_enqueued_job(GoogleScrapingJobManagementJob)
          end
        end

        context 'given no keyword csv' do
          it 'redirects to keywords path' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/no_keywords.csv', 'text/csv')

            post :create, params: { csv_import_form: { file: file } }

            expect(response).to redirect_to(keywords_path)
          end

          it 'shows an alert flash' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/no_keywords.csv', 'text/csv')

            post :create, params: { csv_import_form: { file: file } }

            expect(flash[:alert]).to eql(I18n.t('keyword.keyword_range'))
          end

          it 'does NOT insert keywords to database' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/no_keywords.csv')

            expect do
              post :create, params: { csv_import_form: { file: file } }
            end.to change(Keyword, :count).by(0)
          end

          it 'does NOT create google scraping worker sidekiq job' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/no_keywords.csv')

            expect do
              post :create, params: { csv_import_form: { file: file } }
            end.not_to have_enqueued_job(GoogleScrapingJobManagementJob)
          end
        end

        context 'given more than 1,000 keywords csv' do
          it 'redirects to keywords path' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')

            post :create, params: { csv_import_form: { file: file } }

            expect(response).to redirect_to(keywords_path)
          end

          it 'shows an alert flash' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')

            post :create, params: { csv_import_form: { file: file } }

            expect(flash[:alert]).to eql(I18n.t('keyword.keyword_range'))
          end

          it 'does NOT insert keywords to database' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/more_than_thoudsand_keywords.csv')

            expect do
              post :create, params: { csv_import_form: { file: file } }
            end.to change(Keyword, :count).by(0)
          end

          it 'does NOT create google scraping worker sidekiq job' do
            user = Fabricate(:user)
            session[:user_id] = user[:id]
            file = fixture_file_upload('files/more_than_thoudsand_keywords.csv')

            expect do
              post :create, params: { csv_import_form: { file: file } }
            end.not_to have_enqueued_job(GoogleScrapingJobManagementJob)
          end
        end
      end
    end
  end
end
