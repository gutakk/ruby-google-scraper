# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::KeywordsController, type: :controller do
  describe 'GET#index' do
    context 'given access token' do
      it 'returns ok status code' do
        user = Fabricate(:user)
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)

        request.headers['Authorization'] = "Bearer #{access_token.token}"

        get :index

        expect(response).to have_http_status(:ok)
      end

      it 'returns keywords for valid resource owner' do
        user = Fabricate(:user)
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
        Fabricate(:keyword, user_id: user.id, keyword: 'Lionel Messi')
        Fabricate(:keyword, user_id: user.id, keyword: 'Cristiano Ronaldo')

        request.headers['Authorization'] = "Bearer #{access_token.token}"

        get :index

        expect(JSON.parse(response.body)['data'].count).to eql 2
      end

      it 'does NOT return keywords for invalid resource owner' do
        user1 = Fabricate(:user)
        user2 = Fabricate(:user, username: 'hello', password: 'password', password_confirmation: 'password')
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, resource_owner_id: user2.id, application_id: application.id)
        Fabricate(:keyword, user_id: user1.id, keyword: 'Lionel Messi')
        Fabricate(:keyword, user_id: user1.id, keyword: 'Cristiano Ronaldo')

        request.headers['Authorization'] = "Bearer #{access_token.token}"

        get :index

        expect(JSON.parse(response.body)['data'].count).to eql 0
      end

      it 'returns ascending ordered keywords' do
        user = Fabricate(:user)
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
        Fabricate(:keyword, user_id: user.id, keyword: 'Eden Hazard')
        Fabricate(:keyword, user_id: user.id, keyword: 'Lionel Messi')
        Fabricate(:keyword, user_id: user.id, keyword: 'Cristiano Ronaldo')
        Fabricate(:keyword, user_id: user.id, keyword: 'Kylian Mbappe')
        Fabricate(:keyword, user_id: user.id, keyword: 'Neymar')
        Fabricate(:keyword, user_id: user.id, keyword: 'Kevin De Bruyne')

        request.headers['Authorization'] = "Bearer #{access_token.token}"

        get :index

        response_body = JSON.parse(response.body)

        expect(response_body['data'].count).to eql 6
        expect(response_body['data'][0]['attributes']['keyword']).to eql('Cristiano Ronaldo')
        expect(response_body['data'][1]['attributes']['keyword']).to eql('Eden Hazard')
        expect(response_body['data'][2]['attributes']['keyword']).to eql('Kevin De Bruyne')
        expect(response_body['data'][3]['attributes']['keyword']).to eql('Kylian Mbappe')
        expect(response_body['data'][4]['attributes']['keyword']).to eql('Lionel Messi')
        expect(response_body['data'][5]['attributes']['keyword']).to eql('Neymar')
      end

      it 'returns only 25 keywords per page' do
        user = Fabricate(:user)
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
        Fabricate.times(60, :keyword, user_id: user.id, keyword: FFaker::Name.name)

        request.headers['Authorization'] = "Bearer #{access_token.token}"

        get :index

        expect(JSON.parse(response.body)['data'].count).to eql 25
      end

      it 'returns only keywords that match with search params' do
        user = Fabricate(:user)
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
        Fabricate(:keyword, user_id: user.id, keyword: 'Eden Hazard')
        Fabricate(:keyword, user_id: user.id, keyword: 'Lionel Messi')
        Fabricate(:keyword, user_id: user.id, keyword: 'Cristiano Ronaldo')
        Fabricate(:keyword, user_id: user.id, keyword: 'Kylian Mbappe')
        Fabricate(:keyword, user_id: user.id, keyword: 'Neymar')
        Fabricate(:keyword, user_id: user.id, keyword: 'Kevin De Bruyne')

        request.headers['Authorization'] = "Bearer #{access_token.token}"

        get :index, params: { search: 'ian' }

        response_body = JSON.parse(response.body)

        expect(response_body['data'].count).to eql 2
        expect(response_body['data'][0]['attributes']['keyword']).to eql('Cristiano Ronaldo')
        expect(response_body['data'][1]['attributes']['keyword']).to eql('Kylian Mbappe')
      end

      it 'returns nothing when given page 2 but keywords less than 25' do
        user = Fabricate(:user)
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
        Fabricate(:keyword, user_id: user.id, keyword: 'Eden Hazard')
        Fabricate(:keyword, user_id: user.id, keyword: 'Lionel Messi')
        Fabricate(:keyword, user_id: user.id, keyword: 'Cristiano Ronaldo')
        Fabricate(:keyword, user_id: user.id, keyword: 'Kylian Mbappe')
        Fabricate(:keyword, user_id: user.id, keyword: 'Neymar')
        Fabricate(:keyword, user_id: user.id, keyword: 'Kevin De Bruyne')

        request.headers['Authorization'] = "Bearer #{access_token.token}"

        get :index, params: { page: 2 }

        response_body = JSON.parse(response.body)

        expect(response_body['data'].count).to eql 0
      end
    end

    context 'given NO access token' do
      it 'returns unauthorized status code' do
        get :index

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns invalid token message' do
        get :index

        response_body = JSON.parse(response.body)

        expect(response_body['errors'][0]['detail']).to eql(I18n.t('doorkeeper.errors.messages.invalid_token.unknown'))
      end
    end

    context 'given wrong access token' do
      it 'returns unauthorized status code' do
        request.headers['Authorization'] = 'xxx'

        get :index

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns invalid token message' do
        request.headers['Authorization'] = 'xxx'

        get :index

        expect(JSON.parse(response.body)['errors'][0]['detail']).to eql(I18n.t('doorkeeper.errors.messages.invalid_token.unknown'))
      end
    end

    context 'given revoked access token' do
      it 'returns unauthorized status code' do
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, application_id: application.id, revoked_at: DateTime.now)

        request.headers['Authorization'] = "Bearer #{access_token.token}"

        get :index

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns token was revoked message' do
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, application_id: application.id, revoked_at: DateTime.now)

        request.headers['Authorization'] = "Bearer #{access_token.token}"

        get :index

        expect(JSON.parse(response.body)['errors'][0]['detail']).to eql(I18n.t('doorkeeper.errors.messages.invalid_token.revoked'))
      end
    end

    context 'given expired access token' do
      it 'returns unauthorized status code' do
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, application_id: application.id, expires_in: 0)

        request.headers['Authorization'] = "Bearer #{access_token.token}"

        get :index

        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns token was expired message' do
        application = Fabricate(:application)
        access_token = Fabricate(:access_token, application_id: application.id, expires_in: 0)

        request.headers['Authorization'] = "Bearer #{access_token.token}"

        get :index

        expect(JSON.parse(response.body)['errors'][0]['detail']).to eql(I18n.t('doorkeeper.errors.messages.invalid_token.expired'))
      end
    end
  end

  describe 'GET#show' do
    context 'given access token' do
      context 'given correct keyword id' do
        it 'returns ok status code' do
          user = Fabricate(:user)
          application = Fabricate(:application)
          access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
          keyword = Fabricate(:keyword, user_id: user.id, keyword: 'test')

          request.headers['Authorization'] = "Bearer #{access_token.token}"

          get :show, params: { id: keyword.id }

          expect(response).to have_http_status(:ok)
        end

        it 'returns correct keyword' do
          user = Fabricate(:user)
          application = Fabricate(:application)
          access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
          keyword = Fabricate(:keyword, user_id: user.id, keyword: 'test')

          request.headers['Authorization'] = "Bearer #{access_token.token}"

          get :show, params: { id: keyword.id }

          response_body = JSON.parse(response.body)

          expect(response_body['data']['id']).to eql(keyword.id.to_s)
          expect(response_body['data']['attributes']['keyword']).to eql('test')
        end
      end

      context 'given incorrect keyword id' do
        it 'returns not found status code' do
          user = Fabricate(:user)
          application = Fabricate(:application)
          access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
          Fabricate(:keyword, user_id: user.id, keyword: 'test')

          request.headers['Authorization'] = "Bearer #{access_token.token}"

          get :show, params: { id: 9999 }

          expect(response).to have_http_status(:not_found)
        end

        it 'returns not found message' do
          user = Fabricate(:user)
          application = Fabricate(:application)
          access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
          Fabricate(:keyword, user_id: user.id, keyword: 'test')

          request.headers['Authorization'] = "Bearer #{access_token.token}"

          get :show, params: { id: 9999 }

          expect(JSON.parse(response.body)['errors'][0]['detail']).to include(I18n.t('keyword.not_found_with_id', id: 9999))
        end
      end
    end

    context 'given NO access token' do
      it 'returns unauthorized status code' do
        user = Fabricate(:user)
        keyword = Fabricate(:keyword, user_id: user.id, keyword: 'test')

        get :show, params: { id: keyword.id }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST#create' do
    context 'given access token' do
      context 'given valid parameters (file)' do
        it 'returns ok status code' do
          user = Fabricate(:user)
          application = Fabricate(:application)
          access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
          file = fixture_file_upload('files/example.csv', 'text/csv')

          request.headers['Authorization'] = "Bearer #{access_token.token}"

          post :create, params: { file: file }

          expect(response).to have_http_status(:no_content)
        end

        it 'inserts keywords to database' do
          user = Fabricate(:user)
          application = Fabricate(:application)
          access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
          file = fixture_file_upload('files/example.csv', 'text/csv')

          request.headers['Authorization'] = "Bearer #{access_token.token}"

          expect do
            post :create, params: { file: file }
          end.to change(Keyword, :count).by(6)
        end

        it 'creates google scraping job' do
          user = Fabricate(:user)
          application = Fabricate(:application)
          access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
          file = fixture_file_upload('files/example.csv', 'text/csv')

          request.headers['Authorization'] = "Bearer #{access_token.token}"

          expect do
            post :create, params: { file: file }
          end.to have_enqueued_job(ScrapingProcessDistributingJob)
        end
      end

      context 'given invalid parameters (file)' do
        context 'given NO file' do
          it 'returns bad request status code' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            post :create

            expect(response).to have_http_status(:bad_request)
          end

          it 'returns invalid file type message' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            post :create

            expect(JSON.parse(response.body)['errors'][0]['detail']).to eql(I18n.t('keyword.file_cannot_be_blank'))
          end

          it 'does NOT insert keywords to database' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            expect do
              post :create
            end.to change(Keyword, :count).by(0)
          end

          it 'does NOT create google scraping job' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            expect do
              post :create
            end.not_to have_enqueued_job(ScrapingProcessDistributingJob)
          end
        end

        context 'given invalid file type' do
          it 'returns bad request status code' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/nimble.png')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            post :create, params: { file: file }

            expect(response).to have_http_status(:bad_request)
          end

          it 'returns invalid file type message' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/nimble.png')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            post :create, params: { file: file }

            expect(JSON.parse(response.body)['errors'][0]['detail']).to eql(I18n.t('keyword.file_must_be_csv'))
          end

          it 'does NOT insert keywords to database' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/nimble.png')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            expect do
              post :create, params: { file: file }
            end.to change(Keyword, :count).by(0)
          end

          it 'does NOT create google scraping job' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/nimble.png')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            expect do
              post :create, params: { file: file }
            end.not_to have_enqueued_job(ScrapingProcessDistributingJob)
          end
        end

        context 'given no keyword csv' do
          it 'returns bad request status code' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/no_keywords.csv', 'text/csv')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            post :create, params: { file: file }

            expect(response).to have_http_status(:bad_request)
          end

          it 'returns invalid csv message' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/no_keywords.csv', 'text/csv')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            post :create, params: { file: file }

            expect(JSON.parse(response.body)['errors'][0]['detail']).to eql(I18n.t('keyword.keyword_range'))
          end

          it 'does NOT insert keywords to database' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/no_keywords.csv', 'text/csv')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            expect do
              post :create, params: { file: file }
            end.to change(Keyword, :count).by(0)
          end

          it 'does NOT create google scraping job' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/no_keywords.csv', 'text/csv')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            expect do
              post :create, params: { file: file }
            end.not_to have_enqueued_job(ScrapingProcessDistributingJob)
          end
        end

        context 'given more than 1,000 keywords csv' do
          it 'returns bad request status code' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            post :create, params: { file: file }

            expect(response).to have_http_status(:bad_request)
          end

          it 'returns invalid csv message' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            post :create, params: { file: file }

            expect(JSON.parse(response.body)['errors'][0]['detail']).to eql(I18n.t('keyword.keyword_range'))
          end

          it 'does NOT insert keywords to database' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            expect do
              post :create, params: { file: file }
            end.to change(Keyword, :count).by(0)
          end

          it 'does NOT create google scraping job' do
            user = Fabricate(:user)
            application = Fabricate(:application)
            access_token = Fabricate(:access_token, resource_owner_id: user.id, application_id: application.id)
            file = fixture_file_upload('files/more_than_thoudsand_keywords.csv', 'text/csv')

            request.headers['Authorization'] = "Bearer #{access_token.token}"

            expect do
              post :create, params: { file: file }
            end.not_to have_enqueued_job(ScrapingProcessDistributingJob)
          end
        end
      end
    end
  end
end
