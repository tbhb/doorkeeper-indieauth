# frozen_string_literal: true

require 'doorkeeper/oauth/client'
require 'doorkeeper/oauth/client/credentials'
require 'doorkeeper/request/authorization_code'

module Doorkeeper
  module IndieAuth
    module Request
      # Exstension to Doorkeeper::Request::Authorization to support IndieAuth.
      class AuthorizationCode < Doorkeeper::Request::AuthorizationCode
        def request
          @request ||= Doorkeeper::OAuth::AuthorizationCodeRequest.new(
            Doorkeeper.config,
            grant,
            client,
            parameters
          )
        end

        def application
          @application ||= Doorkeeper.config.application_model.find_by(url: parameters[:client_id])
        end

        def client
          @client ||= Doorkeeper::OAuth::Client.new(application)
        end

        private

        def grant
          raise Errors::MissingRequiredParameter, :code if parameters[:code].blank?

          Doorkeeper.config.access_grant_model.by_token(parameters[:code])
        end
      end
    end
  end
end
