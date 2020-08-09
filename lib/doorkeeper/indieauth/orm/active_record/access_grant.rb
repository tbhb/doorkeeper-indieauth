module Doorkeeper
  module IndieAuth
    module AccessGrant
      extend ActiveSupport::Concern

      included do
        include Doorkeeper::Models::AccessGrantMixin
      end
    end
  end
end
