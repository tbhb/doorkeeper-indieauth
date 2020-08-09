# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/indieauth/token', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:oauth_application) }

  describe 'GET /indieauth/token' do
    context 'with a valid token' do
      let(:access_token) do
        FactoryBot.create(:oauth_access_token, application: application, resource_owner_id: user.id)
      end
      let(:auth_header) { { 'Authorization': "Bearer #{access_token.token}" } }

      it 'returns HTTP success' do
        get '/indieauth/token', headers: auth_header
        expect(response).to have_http_status(:success)
      end

      it 'returns profile information in the response' do
        get '/indieauth/token', headers: auth_header
        expect(JSON.parse(response.body).keys).to include('profile')
      end
    end

    context 'with an invalid token' do
      it 'returns HTTP unauthorized' do
        get '/indieauth/token', headers: { 'Authorization': 'Bearer invalid-token' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /indieauth/token' do
    context 'with a valid access grant' do
      let(:access_grant) do
        FactoryBot.create(:oauth_access_grant, resource_owner_id: user.id, application: application)
      end
      let(:plaintext_token) { access_grant.plaintext_token }
      let(:params) do
        {
          grant_type: 'authorization_code',
          client_id: application.url,
          code: plaintext_token,
          redirect_uri: access_grant.redirect_uri
        }
      end

      it 'returns profile information in the response' do
        post '/indieauth/token', params: params
        expect(JSON.parse(response.body).keys).to include('profile')
      end
    end
  end
end
