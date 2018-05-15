# frozen_string_literal: true

require 'gtk3'
require 'mixlib-cli'

unless $LOAD_PATH.include?(File.expand_path('', __dir__))
  $LOAD_PATH.unshift(File.expand_path('', __dir__))
end

require 'volay/version'
require 'volay/app'
require 'volay/cli'
require 'volay/widget/events'
