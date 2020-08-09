# frozen_string_literal: true

require 'rails/engine'

module Doorkeeper
  module IndieAuth
    # Rails engine for Doorkeeper IndieAuth.
    class Engine < ::Rails::Engine
      initializer 'doorkeeper.indieauth.inflections' do
        ActiveSupport::Inflector.inflections(:en) do |inflect|
          inflect.acronym 'IndieAuth'
        end
      end
    end
  end
end
