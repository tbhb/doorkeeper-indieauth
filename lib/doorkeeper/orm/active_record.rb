module Doorkeeper
  AccessGrant.prepend(Doorkeeper::IndieAuth::ORM::Mixins::AccessGrant)
  AccessToken.prepend(Doorkeeper::IndieAuth::ORM::Mixins::AccessToken)
  Application.prepend(Doorkeeper::IndieAuth::ORM::Mixins::Application)
end
