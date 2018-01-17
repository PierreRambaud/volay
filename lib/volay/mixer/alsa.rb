# frozen_string_literal: true

# Volay module
module Volay
  # Mixer module
  module Mixer
    # Alsa class for playing with amixer
    class Alsa < Default
      DEFAULT_VALUE = 2

      def up(value = DEFAULT_VALUE)
        command("-q set Master #{value}%+")
      end

      def down(value = DEFAULT_VALUE)
        command("-q set Master #{value}%-")
      end

      def value=(value)
        command("-q set Master #{value}%")
      end

      def toggle
        command('-q set Master toggle')
      end

      def current
        result = command('get Master')
        max_value = result.match(/ 0 - (\d+)/)[1].to_i
        current_percent = result.match(/\[([0-9]+)%\]\s+\[o(?:n|ff)\]/)[1].to_i
        current_value = ((current_percent * max_value) / 100).to_i
        current_state = result.match(/\[([a-z]+)\]/)[1].to_s

        {
          value: current_value,
          max_value: max_value,
          percent: current_percent,
          muted: current_state != 'on'
        }
      end

      private

      def command(cmd)
        result = Mixlib::ShellOut.new("amixer #{cmd}")
        result.run_command
        Volay::Config.logger.error(result.stderr) unless result.stderr.empty?
        result.stdout
      end
    end
  end
end
