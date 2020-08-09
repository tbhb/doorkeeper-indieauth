# frozen_string_literal: true

require 'doorkeeper/oauth'
require 'doorkeeper/oauth/client'
require 'doorkeeper/oauth/error_response'
require 'doorkeeper/oauth/helpers/scope_checker'
require 'doorkeeper/oauth/helpers/uri_checker'
require 'doorkeeper/oauth/invalid_request_response'
require 'doorkeeper/oauth/pre_authorization'
require 'doorkeeper/oauth/scopes'
require 'doorkeeper/validations'

module Doorkeeper
  module IndieAuth
    module OAuth
      # Extension of Doorkeeper::OAuth::PreAuthorization for IndieAuth.
      class PreAuthorization < Doorkeeper::OAuth::PreAuthorization
        include Doorkeeper::Validations

        validate :client_id, error: :invalid_request
        validate :client, error: :invalid_client
        validate :redirect_uri, error: :invalid_redirect_uri
        validate :params, error: :invalid_request
        validate :response_type, error: :unsupported_response_type
        validate :scopes, error: :invalid_scope
        validate :code_challenge_method, error: :invalid_code_challenge_method

        attr_reader :client, :client_id, :code_challenge, :code_challenge_method, :missing_param,
                    :redirect_uri, :resource_owner, :response_type, :state

        def initialize(_server, parameters = {}, _resource_owner = nil)
          super

          @me = parameters[:me]
        end

        def scopes
          Doorkeeper::OAuth::Scopes.from_string(scope)
        end

        def scope
          if response_type == 'id' || @scope.blank?
            'profile'
          else
            @scope.presence || (server.default_scopes.presence && build_scopes)
          end
        end

        private

        def validate_client
          @client = Doorkeeper.config.application_model.find_by(url: client_id)
          return true if @client.present?

          @client = Doorkeeper.config.application_model.create(
            name: client_id, # TODO: Get from client discovery.
            url: client_id,
            confidential: false,
            redirect_uri: redirect_uri,
            scopes: scopes
          )
          @client.persisted?
        end

        def validate_redirect_uri
          return false if redirect_uri.blank?

          checker = Doorkeeper::OAuth::Helpers::URIChecker
          return true if checker.oob_uri?(redirect_uri)

          # TODO: Support off-domain redirect URIs via client discovery.
          uri = checker.as_uri(redirect_uri)
          client_uri = URI.parse(client_id)
          checker.valid?(redirect_uri) && uri.host == client_uri.host
        end

        def validate_response_type
          %w[code id].include?(response_type)
        end

        def pre_auth_hash
          super.merge(me: me)
        end
      end
    end
  end
end
