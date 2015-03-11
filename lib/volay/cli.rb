# Volay module
module Volay
  # CLI implementation
  class CLI
    include Mixlib::CLI

    banner('Volay, the Volume System Tray.')

    option(:help,
           short: '-h',
           long: '--help',
           description: 'Show this message',
           on: :tail,
           boolean: true,
           show_options: true,
           exit: 0)

    option(:log_level,
           short: '-l LEVEL',
           long: '--log_level LEVEL',
           description: 'Set the log level (debug, info, warn, error, fatal)',
           default: :info,
           proc: proc { |l| l.to_sym })
  end
end
