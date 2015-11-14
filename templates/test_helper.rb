if ENV.fetch("COVERAGE", false)
  require "simplecov"
  SimpleCov.start "rails"
end

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'webmock/minitest'

module Minitest::Expectations
  infect_an_assertion :assert_redirected_to, :must_redirect_to
  infect_an_assertion :assert_template, :must_render_template
  infect_an_assertion :assert_response, :must_respond_with
end

Dir[Rails.root.join('test/support/**/*.rb')].each{ |file| require file }

class ActiveSupport::TestCase
  fixtures :all
end

Capybara.javascript_driver = :webkit
Capybara.default_driver = :webkit

WebMock.disable_net_connect!(allow_localhost: true)
