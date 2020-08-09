# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'IndieAuth::Authorizations', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:application) { FactoryBot.create(:oauth_application, :public) }

  describe 'POST /indieauth/auth' do
    context 'with a valid parameters for authentication' do
      let(:access_grant) do
        FactoryBot.create(:oauth_access_grant, resource_owner_id: user.id, application: application)
      end
      let(:plaintext_token) { access_grant.plaintext_token }
      let(:params) do
        {
          client_id: application.url,
          code: plaintext_token,
          redirect_uri: access_grant.redirect_uri
        }
      end

      it 'returns the canonical profile URL in the response' do
        post '/indieauth/authorize', params: params
        expect(JSON.parse(response.body)['me']).to eq(user.canonical_profile_url)
      end

      it 'returns profile information in the response' do
        post '/indieauth/authorize', params: params
        expect(JSON.parse(response.body).keys).to include('profile')
      end
    end
  end
end
