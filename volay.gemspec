# frozen_string_literal: true

require File.expand_path('lib/volay/version', __dir__)

Gem::Specification.new do |s|
  s.name = 'volay'
  s.version = Volay::VERSION
  s.authors = ['Pierre Rambaud']
  s.email = 'pierre.rambaud86@gmail.com'
  s.license = 'GPL-3.0'
  s.summary = 'The Volume system tray'
  s.homepage = 'http://github.com/PierreRambaud/volay'
  s.description = 'Really simple volume system tray written in ruby.'
  s.executables = ['volay']
  s.files = File.read(File.expand_path('MANIFEST', __dir__)).split("\n")

  s.required_ruby_version = '> 2.3'

  s.add_dependency 'glib2', '~>3.2'
  s.add_dependency 'gtk3', '~>3.2'
  s.add_dependency 'mixlib-cli', '~>1.7'
  s.add_dependency 'mixlib-shellout', '~>2.3'

  s.add_development_dependency 'fakefs', '~>0.20'
  s.add_development_dependency 'rack', '~>2.0'
  s.add_development_dependency 'rack-test', '~>0.8'
  s.add_development_dependency 'rake', '~>12.3'
  s.add_development_dependency 'rspec', '~>3.8'
  s.add_development_dependency 'rubocop', '~>0.69'
  s.add_development_dependency 'rubocop-performance', '~>1.3'
  s.add_development_dependency 'simplecov', '~>0.16'
end
