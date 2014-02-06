# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'tirantes/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 1.9.3'
  s.add_dependency 'bundler', '~> 1.3'
  s.add_dependency 'rails', '4.0.1'
  s.add_development_dependency 'aruba', '~> 0.5.2'
  s.add_development_dependency 'cucumber', '~> 1.2'
  s.authors = ['thoughtbot']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Suspenders is a base Rails project that you can upgrade. It is used by
thoughtbot to get a jump start on a working app. Use Suspenders if you're in a
rush to build something amazing; don't use it if you like missing deadlines.
  HERE

  s.email = 'support@thoughtbot.com'
  s.executables = `git ls-files -- bin/*`.split("\n").map { |file| File.basename(file) }
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/thoughtbot/suspenders'
  s.license = 'MIT'
  s.name = 'tirantes'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "Generate a Rails app using thoughtbot's best practices."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Tirantes::VERSION
end