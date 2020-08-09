# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/migraiton'

module Doorkeeper
  module IndieAuth
    # Install Doorkeeper IndieAuth.
    class InstallGenerator < ::Rails::Generators::Base
      include ::Rails::Generators::Migration

      namespace 'doorkeeper:indieauth:install'
      source_root File.expand_path('templates', __dir__)
      desc 'Installs Doorkeeper IndieAuth'

      def install
        template 'initializer.rb', 'config/initializers/doorkeeper_indieauth.rb'
        copy_file File.expand_path('../../../../config/locales/en.yml', __dir__),
                  'config/locales/doorkeeper-indieauth.en.yml'
        # route 'use_doorkeeper_indieauth'
        readme 'README'
      end
    end
  end
end
