module Doorkeeper
  module IndieAuth
    module Models
      module AccessTokenMixin
        extend ActiveSupport::Concern

        def as_indieauth_json(_options = {})
          resource_owner.as_indieauth_json.merge(
            scope: scopes.to_a.join(' '),
            expires_in: expires_in_seconds,
            client_id: application.url,
            created_at: created_at.to_i
          )
        end
      end
    end
  end
end
