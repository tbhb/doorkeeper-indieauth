# frozen_string_literal: true

require 'indieauth/pre_authorization'

module Doorkeeper
  module IndieAuth
    # IndieAuth authorizations endpoint.
    class AuthorizationsController < Doorkeeper::AuthorizationsController
      skip_before_action :verify_authenticity_token, only: %i[create]
      skip_before_action :authenticate_resource_owner!, only: %i[create]

      def create
        if params[:code]
          render_authenticate_response
        else
          verify_authenticity_token
          authenticate_resource_owner!
          redirect_or_render authorize_response
        end
      end

      private

      def render_authenticate_response # rubocop:disable Metrics/AbcSize
        if %i[code client_id redirect_uri].any? { |p| params[p].blank? }
          render_invalid_request(:missing_param)
        elsif grant.blank?
          render_invalid_grant
        elsif params[:client_id] != grant.application.url && params[:redirect_uri] != grant.redirect_uri
          render_invalid_grant
        else
          render json: grant.user.to_indieauth_json
        end
      end

      def render_invalid_request(reason)
        description = I18n.t(reason, scope: %i[doorkeeper errors messages invalid_request])
        render json: { error: 'invalid_request', error_description: description }, status: :bad_request
      end

      def render_invalid_grant
        description = I18n.t(:invalid_grant, scope: %i[doorkeeper errors messages])
        render json: { error: 'invalid_grant', error_description: description }, status: :bad_request
      end

      def grant
        @grant ||= Auth::AccessGrant.by_token(params[:code])
      end

      def pre_auth
        @pre_auth ||= IndieAuth::PreAuthorization.new(
          Doorkeeper.configuration,
          pre_auth_params,
          current_resource_owner
        )
      end

      def pre_auth_param_fields
        %i[
          client_id
          code_challenge
          code_challenge_method
          me
          response_type
          redirect_uri
          scope state
        ]
      end

      def strategy
        # IndieAuth supports both code and id, but the authorization request strategy is the same.
        #
        # https://indieauth.spec.indieweb.org/#authentication
        @strategy ||= server.authorization_request('code')
      end
    end
  end
end
