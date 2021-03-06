# frozen_string_literal: true

require 'gtk3'
require 'logger'
require 'mixlib/cli'
require 'mixlib/shellout'

$LOAD_PATH.unshift(File.expand_path('', __dir__)) unless
  $LOAD_PATH.include?(File.expand_path('', __dir__))

require 'volay/version'
require 'volay/config'
require 'volay/exceptions'
require 'volay/app'
require 'volay/cli'
require 'volay/utils'
require 'volay/widget/events'
require 'volay/widget/system_tray'
require 'volay/widget/volume_control'
require 'volay/mixer/default'
require 'volay/mixer/pulse'
