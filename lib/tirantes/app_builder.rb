module Tirantes
  class AppBuilder < Rails::AppBuilder
    include Tirantes::Actions

    def readme
      template 'README.md.erb', 'README.md'
    end

    def raise_on_delivery_errors
      replace_in_file 'config/environments/development.rb',
        'raise_delivery_errors = false', 'raise_delivery_errors = true'
    end

    def raise_on_unpermitted_parameters
      action_on_unpermitted_parameters = <<-RUBY

  # Raise an ActionController::UnpermittedParameters exception when
  # a parameter is not explcitly permitted but is passed anyway.
  config.action_controller.action_on_unpermitted_parameters = :raise
      RUBY
      inject_into_file(
        "config/environments/development.rb",
        action_on_unpermitted_parameters,
        before: "\nend"
      )
    end

    def provide_setup_script
      foreman = <<-RUBY
      # Set up Rails app. Run this script immediately after cloning the codebase.
      # https://github.com/thoughtbot/guides/tree/master/protocol

      # Set up configurable environment variables
      if [ ! -f .env ]; then
        cp .sample.env .env
      fi

      # Pick a port for Foreman
      echo "port: 7000" > .foreman

      # Set up DNS via Pow
      if [ -d ~/.pow ]
      then
        echo 7000 > ~/.pow/`basename $PWD`
      else
        echo "Pow not set up but the team uses it for this project. Setup: http://goo.gl/RaDPO"
      fi
      RUBY

      append_file 'bin/setup', foreman
      run 'chmod a+x bin/setup'
    end

    def configure_generators
      config = <<-RUBY
    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :mini_test, :spec => false, :fixture => true
      generate.view_specs false
    end

      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_exception_notifier
      copy_file 'exception_notification.rb', 'config/initializers/exception_notification.rb'
    end

    def configure_smtp
      copy_file 'smtp.rb', 'config/initializers/smtp.rb'

      prepend_file 'config/environments/production.rb',
        "require Rails.root.join('config/initializers/smtp')\n"

      config = <<-RUBY

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
      RUBY

      inject_into_file 'config/environments/production.rb', config,
        :after => 'config.action_mailer.raise_delivery_errors = false'
    end

    def configure_tools
      copy_file 'reek.rake', 'lib/tasks/reek.rake'
      copy_file 'rubocop.rake', 'lib/tasks/rubocop.rake'
      copy_file 'bullet.rb', 'config/initializers/bullet.rb'
    end

    def setup_staging_environment
      run 'cp config/environments/production.rb config/environments/staging.rb'

      prepend_file 'config/environments/staging.rb',
        "Mail.register_interceptor RecipientInterceptor.new(ENV['EMAIL_RECIPIENTS'])\n"
    end

    def setup_secret_token
      template 'secret_token.rb.erb', 'config/initializers/secret_token.rb', :force => true
    end

    def create_partials_directory
      empty_directory 'app/views/application'
    end

    def create_shared_flashes
      copy_file '_flashes.html.erb', 'app/views/application/_flashes.html.erb'
    end

    def create_shared_javascripts
      copy_file '_javascript.html.erb', 'app/views/application/_javascript.html.erb'
    end

    def create_application_layout
      template 'tirantes_layout.html.erb.erb',
        'app/views/layouts/application.html.erb',
        :force => true
    end

    def create_common_javascripts
      directory 'javascripts', 'app/assets/javascripts'
    end

    def use_postgres_config_template
      template 'postgresql_database.yml.erb', 'config/database.yml',
        :force => true
    end

    def create_database
      bundle_command 'exec rake db:create'
    end

    def replace_gemfile
      remove_file 'Gemfile'
      copy_file 'Gemfile_clean', 'Gemfile'
    end

    def set_ruby_to_version_being_used
      inject_into_file 'Gemfile', "\n\nruby '#{RUBY_VERSION}'",
        after: /source 'https:\/\/rubygems.org'/
    end

    def configure_minitest
      remove_file 'test/test_helper.rb'
      copy_file 'test_helper.rb', 'test/test_helper.rb'
    end

    def configure_background_jobs_for_minitest
      copy_file 'background_jobs_minitest.rb', 'test/support/background_jobs.rb'
      run 'rails g delayed_job:active_record'
    end

    def configure_pretty_formatter
      config = <<-RUBY
    config.log_formatter = PrettyFormatter.formatter

      RUBY
      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_active_job
      config = <<-RUBY
    config.active_job.queue_adapter = :delayed_job
      RUBY

      inject_into_class "config/application.rb", "Application", config
    end

    def configure_time_formats
      remove_file 'config/locales/en.yml'
      copy_file 'config_locales_en.yml', 'config/locales/en.yml'
    end

    def download_es_locales
      copy_file 'config_locales_es.yml', 'config/locales/es.yml'
    end

    def download_purecss
      copy_file 'pure-min.css', 'vendor/assets/stylesheets/pure-min.css'
      copy_file 'grids-responsive-min.css', 'vendor/assets/stylesheets/grids-responsive-min.css'
    end

    def configure_rack_timeout
      copy_file 'rack_timeout.rb', 'config/initializers/rack_timeout.rb'
    end

    def configure_action_mailer
      action_mailer_host 'development', "#{app_name}.dev"
      action_mailer_host 'test',  "#{app_name}.test"
      action_mailer_host 'staging', "staging.#{app_name}.com"
      action_mailer_host 'production', "#{app_name}.com"
    end

    def generate_minitest
      generate 'rails g minitest:install'
    end

    def configure_puma
      copy_file 'puma.rb', 'config/puma.rb'
    end

    def setup_foreman
      copy_file 'sample.env', '.sample.env'
      copy_file 'Procfile', 'Procfile'
    end

    def setup_stylesheets
      remove_file 'app/assets/stylesheets/application.css'
      copy_file 'application.css.scss',
        'app/assets/stylesheets/application.css.scss'
      [
        'app/assets/stylesheets/base',
        'app/assets/stylesheets/layout',
        'app/assets/stylesheets/modules'
      ].each do |dir|
        run "mkdir #{dir}"
        run "touch #{dir}/.keep"
      end
    end

    def gitignore_files
      remove_file '.gitignore'
      copy_file 'tirantes_gitignore', '.gitignore'
      [
        'app/views/pages',
        'test/lib',
        'test/controllers',
        'test/models',
        'test/integration',
        'test/helpers',
        'test/support/matchers',
        'test/support/mixins',
        'test/support/shared_examples'
      ].each do |dir|
        run "mkdir #{dir}"
        run "touch #{dir}/.keep"
      end
    end

    def init_git
      run 'git init'
    end

    def create_heroku_apps
      path_addition = override_path_for_tests
      run "#{path_addition} heroku create #{app_name}-production --remote=production"
      run "#{path_addition} heroku create #{app_name}-staging --remote=staging"
      run "#{path_addition} heroku config:add RACK_ENV=staging RAILS_ENV=staging --remote=staging"
    end

    def set_heroku_remotes
      remotes = <<-RUBY

# Set up staging and production git remotes
git remote add staging git@heroku.com:#{app_name}-staging.git
git remote add production git@heroku.com:#{app_name}-production.git
      RUBY

      append_file 'bin/setup', remotes
    end

    def create_github_repo(repo_name)
      path_addition = override_path_for_tests
      run "#{path_addition} hub create #{repo_name}"
    end

    def copy_miscellaneous_files
      copy_file 'errors.rb', 'config/initializers/errors.rb'
    end

    def customize_error_pages
      meta_tags =<<-EOS
  <meta charset='utf-8' />
  <meta name='ROBOTS' content='NOODP' />
      EOS

      %w(500 404 422).each do |page|
        inject_into_file "public/#{page}.html", meta_tags, :after => "<head>\n"
        replace_in_file "public/#{page}.html", /<!--.+-->\n/, ''
      end
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb',
        /Rails\.application\.routes\.draw do.*end/m,
        "Rails\.application.routes.draw do\nend"
    end

    def setup_default_rake_task
      append_file 'Rakefile' do
        "task(:default).clear\ntask :default => ['test:all']\n"
      end
    end

    private

    def override_path_for_tests
      if ENV['TESTING']
        support_bin = File.expand_path(File.join('..', '..', '..', 'features', 'support', 'bin'))
        "PATH=#{support_bin}:$PATH"
      end
    end
  end
end
