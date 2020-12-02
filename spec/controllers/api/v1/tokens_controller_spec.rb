# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::TokensController, type: :controller do
  describe 'POST#revoke' do
    context 'given valid oauth application' do
      it 'returns ok status' do
        application = Fabricate(:application)
        token = Fabricate(:access_token, application_id: application.id)

        post :revoke, params: { token: token.token, client_id: application.uid, client_secret: application.secret }

        expect(response).to have_http_status(:ok)
      end

      it 'returns empty response' do
        application = Fabricate(:application)
        token = Fabricate(:access_token, application_id: application.id)

        post :revoke, params: { token: token.token, client_id: application.uid, client_secret: application.secret }

        expect(JSON.parse(response.body)).to be_empty
      end
    end

    context 'given invalid oauth application' do
      it 'returns forbidden status' do
        application = Fabricate(:application)
        token = Fabricate(:access_token, application_id: application.id)

        post :revoke, params: { token: token.token }

        expect(response).to have_http_status(:forbidden)
      end

      it 'returns an error message' do
        application = Fabricate(:application)
        token = Fabricate(:access_token, application_id: application.id)

        post :revoke, params: { token: token.token }

        expected_response = {
          errors: [
            {
              code: 'unauthorized_client',
              detail: I18n.t('doorkeeper.errors.messages.revoke.unauthorized')
            }
          ]
        }

        expect(JSON.parse(response.body, symbolize_names: true)).to eq(expected_response)
      end
    end
  end
end
