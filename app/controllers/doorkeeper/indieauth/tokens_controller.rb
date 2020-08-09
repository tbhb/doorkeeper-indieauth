# frozen_string_literal: true

require 'doorkeeper/errors'

module Doorkeeper
  module IndieAuth
    # IndieAuth tokens endpoint.
    class TokensController < Doorkeeper::TokensController
      # https://indieauth.spec.indieweb.org/#access-token-verification
      def show
        if doorkeeper_token&.accessible?
          render json: doorkeeper_token.as_indieauth_json, status: :ok
        else
          error = Doorkeeper::OAuth::InvalidTokenResponse.new
          response.headers.merge!(error.headers)
          render json: error.body, status: error.status
        end
      end

      def create
        # IndieAuth specifies that the revocation endpoint is the same as the token endpoint, and that the revocation
        # request includes an additional parameter, `action=revoke`.
        if request.query_parameters[:action] == 'revoke'
          revoke
        else
          headers.merge!(authorize_response.headers)
          render json: authorize_response_body, status: authorize_response.status
        end
      rescue Doorkeeper::Errors::DoorkeeperError => e
        handle_token_exception(e)
      end

      private

      # OAuth 2.0 Token Revocation - http://tools.ietf.org/html/rfc7009
      #
      # IndieAuth Token Revocation - https://indieauth.spec.indieweb.org/#token-revocation
      def revoke
        if token.blank?
          render json: {}, status: 200
        elsif authorized?
          revoke_token
          render json: {}, status: 200
        else
          render json: revocation_error_response, status: :forbidden
        end
      end

      def strategy
        @strategy ||= IndieAuth::AuthorizationCodeRequest.new(server)
      end

      def authorize_response_body
        body = authorize_response.body
        user = Auth::AccessToken.find_by(token: body['access_token']).user
        body.merge(user.as_indieauth_json)
      end
    end
  end
end
