require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rails/test_help'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'capybara/poltergeist'
require 'minitest/focus'
require 'minitest/colorize'
require 'webmock/minitest'
require 'database_cleaner'

module Minitest::Expectations
  infect_an_assertion :assert_redirected_to, :must_redirect_to
  infect_an_assertion :assert_template, :must_render_template
  infect_an_assertion :assert_response, :must_respond_with
end

Dir[Rails.root.join('test/support/**/*.rb')].each{ |file| require file }

class ActiveSupport::TestCase
  fixtures :all
end

class Minitest::Unit::TestCase
  class << self
    alias_method :context, :describe
  end
end

Capybara.javascript_driver = :poltergeist
Capybara.default_driver = :poltergeist

WebMock.disable_net_connect!(allow_localhost: true)
