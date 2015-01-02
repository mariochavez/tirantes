# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'tirantes/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 2.1.0'
  s.add_dependency 'bundler', '~> 1.7.0'
  s.add_dependency 'rails', '~>4.2.0'
  s.add_development_dependency 'aruba', '~> 0.5.2'
  s.add_development_dependency 'cucumber', '~> 1.2'
  s.authors = ['Mario Chavez']
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Tirantes is a base Rails project that you can upgrade. It is based on
thoughtbot's suspenders. If you are in a rush and wnat to get a jump start on
a working app Tirantes can help you there.
  HERE

  s.email = 'mario.chavez@fmail.com'
  s.executables = `git ls-files -- bin/*`.split("\n").map { |file| File.basename(file) }
  s.extra_rdoc_files = %w[README.md LICENSE]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'https://github.com/mariochavez/tirantes'
  s.license = 'MIT'
  s.name = 'tirantes'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "Generate a Rails app with better defaults."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Tirantes::VERSION
end
