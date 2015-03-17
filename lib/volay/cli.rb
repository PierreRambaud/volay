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
           in: %w(debug info warn error fatal),
           default: :info,
           proc: proc { |l| l.to_sym })

    option(:up,
           short: '-u PERCENT',
           long: '--up PERCENT',
           description: 'Up volume',
           proc: proc { |l| l.to_i })

    option(:down,
           short: '-d PERCENT',
           long: '--down PERCENT',
           description: 'Down volume',
           proc: proc { |l| l.to_i })

    option(:muted,
           short: '-m',
           long: '--muted',
           boolean: true,
           description: 'Mute volume')
  end
end
