# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Doorkeeper::IndieAuth::OAuth::PreAuthorization, type: :model do
  subject(:pre_auth) do
    described_class.new(
      Doorkeeper.configuration,
      pre_auth_params,
      user
    )
  end

  let(:user) { FactoryBot.create(:user, profile_urls: ['https://example.com/profile']) }

  # TODO: Temporary until we have the client get upserted
  let(:client) { FactoryBot.create(:oauth_application) }
  let(:profile_url) { 'https://example.com/profile' }
  let(:client_id) { 'https://client.net' }
  let(:redirect_uri) { 'https://client.net/auth/callback' }
  let(:response_type) { 'code' }
  let(:scope) { 'profile' }
  let(:pre_auth_params) do
    {
      client_id: client_id,
      redirect_uri: redirect_uri,
      me: profile_url,
      response_type: response_type,
      scope: scope,
      state: '123456'
    }
  end

  it 'is authorizable with valid parameters' do
    expect(pre_auth).to be_authorizable
  end

  context 'when profile URL does not belong to authorizing user' do
    let(:profile_url) { 'https://example.com/different-user' }

    it 'is not authorizable' do
      expect(pre_auth).not_to be_authorizable
    end
  end

  context 'when redirect_uri is on a different domain than client_id' do
    let(:redirect_uri) { 'https://different-domain.com/auth/callback' }

    it 'is not authorizable' do
      expect(pre_auth).not_to be_authorizable
    end
  end
end
