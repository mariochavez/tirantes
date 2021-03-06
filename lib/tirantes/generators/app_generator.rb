require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Tirantes
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, :type => :string, :aliases => '-d', :default => 'postgresql',
      :desc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    class_option :heroku, :type => :boolean, :aliases => '-H', :default => false,
      :desc => 'Create staging and production Heroku apps'

    class_option :github, :type => :string, :aliases => '-G', :default => nil,
      :desc => 'Create Github repository and add remote origin pointed to repo'

    class_option :skip_test_unit, :type => :boolean, :aliases => '-T', :default => true,
      :desc => 'Skip Test::Unit files'

    def finish_template
      invoke :tirantes_customization
      super
    end

    def tirantes_customization
      invoke :customize_gemfile
      invoke :setup_database
      invoke :setup_development_environment
      invoke :setup_test_environment
      invoke :setup_production_environment
      invoke :setup_staging_environment
      invoke :create_tirantes_views
      invoke :setup_coffeescript
      invoke :configure_app
      invoke :setup_stylesheets
      invoke :copy_miscellaneous_files
      invoke :customize_error_pages
      invoke :remove_routes_comment_lines
      invoke :setup_git
      invoke :create_heroku_apps
      invoke :create_github_repo
      invoke :outro
    end

    def customize_gemfile
      build :replace_gemfile
      build :set_ruby_to_version_being_used
      bundle_command 'install'
    end

    def setup_database
      say 'Setting up database'

      if 'postgresql' == options[:database]
        build :use_postgres_config_template
      end

      build :create_database

      say 'If you want to use pg text search, remember to'
      say 'to generate and migrate pg_search_documents table'
      say 'rails g pg_search:migration:multisearch'
      say 'rake db:migrate'
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :raise_on_delivery_errors
      build :raise_on_unpermitted_parameters
      build :provide_setup_script
      build :configure_generators
      build :configure_tools
    end

    def setup_test_environment
      say 'Setting up the test environment'
      build :generate_minitest
      build :configure_minitest
      build :configure_background_jobs_for_minitest
    end

    def setup_production_environment
      say 'Setting up the production environment'
      build :configure_smtp
      build :configure_exception_notifier
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
      build :setup_staging_environment
    end

    def create_tirantes_views
      say 'Creating tirantes views'
      build :create_partials_directory
      build :create_shared_flashes
      build :create_shared_javascripts
      build :create_application_layout
      build :download_es_locales
      build :download_purecss
    end

    def setup_coffeescript
      say 'Setting up CoffeeScript defaults'
      build :create_common_javascripts
    end

    def configure_app
      say 'Configuring app'
      build :configure_action_mailer
      build :configure_strong_parameters
      build :configure_time_formats
      build :configure_active_job
      build :configure_pretty_formatter
      build :configure_rack_timeout
      build :setup_secret_token
      build :setup_default_rake_task
      build :configure_puma
      build :setup_foreman
      build :download_es_locales
    end

    def setup_stylesheets
      say 'Set up stylesheets'
      build :setup_stylesheets
    end

    def setup_git
      if !options[:skip_git]
        say 'Initializing git'
        invoke :setup_gitignore
        invoke :init_git
      end
    end

    def create_heroku_apps
      if options[:heroku]
        say 'Creating Heroku apps'
        build :create_heroku_apps
        build :set_heroku_remotes
      end
    end

    def create_github_repo
      if !options[:skip_git] && options[:github]
        say 'Creating Github repo'
        build :create_github_repo, options[:github]
      end
    end

    def setup_gitignore
      build :gitignore_files
    end

    def init_git
      build :init_git
    end

    def copy_libraries
      say 'Copying libraries'
      build :copy_libraries
    end

    def copy_miscellaneous_files
      say 'Copying miscellaneous support files'
      build :copy_miscellaneous_files
    end

    def customize_error_pages
      say 'Customizing the 500/404/422 pages'
      build :customize_error_pages
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines
    end

    def outro
      say 'Congratulations! You just pulled our tirantes.'
      say 'Please execute bin/setup to complete this application setup'
    end

    def run_bundle
      # Let's not: We'll bundle manually at the right spot
    end

    protected

    def get_builder_class
      Tirantes::AppBuilder
    end

    def using_active_record?
      !options[:skip_active_record]
    end
  end
end
