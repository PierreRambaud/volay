# frozen_string_literal: true

# Volay module
module Volay
  # Mixer module
  module Mixer
    # Pulse class for playing with pacmd command
    class Pulse < Default
      DEFAULT_VALUE = 2
      MAX_VALUE = 65_536

      attr_reader :default_sink_id
      attr_accessor :cards

      def initialize
        @cards = {}
        refresh
      end

      def up(value = DEFAULT_VALUE)
        set_volume(
          volume_percent(@cards[@default_sink_id]['volume']) + value
        )
      end

      def down(value = DEFAULT_VALUE)
        set_volume(
          volume_percent(@cards[@default_sink_id]['volume']) - value
        )
      end

      def value=(value)
        set_volume(value.to_i)
      end

      def toggle
        return if current_sink.nil?

        value = if current_sink['muted'] == 'yes'
                  'no'
                else
                  'yes'
                end
        current_sink['muted'] = value
        command("set-sink-mute #{@cards[@default_sink_id]['sink']} #{value}")
      end

      def current
        {
          value: current_sink.nil? ? 0 : current_sink['volume'],
          max_value: MAX_VALUE,
          percent: current_sink.nil? ? 0 : volume_percent(current_sink['volume']),
          muted: current_sink.nil? ? true : current_sink['muted'] == 'yes'
        }
      end

      ##
      # Change card
      #
      # @param [Integer] newdefault New default index
      #
      def change_card(newdefault)
        return unless @cards.key?(newdefault)

        # Change default sink
        command("set-default-sink #{@cards[newdefault]['sink']}")

        # Now to move all current playing stuff to the new sink....
        dump = command('list-sink-inputs').lines
        dump.each do |line|
          args = line.split
          # We need to find the item index for each playing stream
          if args[0] == 'index:'
            # And now to shift them all to the new sink.
            command("move-sink-input #{args[1]} #{@cards[newdefault]['sink']}")
          end
        end

        refresh
      end

      ##
      # Refresh cards data
      #
      def refresh
        cmd = command('dump')
        return unless cmd

        dump = cmd.lines
        dump.each do |line|
          args = line.split

          # We are using the id to actually enumerate all cards.
          if args[1] == 'module-alsa-card'
            number = args[2].sub('device_id="', '').sub('"', '').to_i
            @cards[number] = {}
            @cards[number]['name'] = args[3].sub('name="', '').sub('"', '')
          # we already have something in the array
          elsif @cards.keys.length.positive?
            set_data(args)
          end
        end

        set_long_names
      end

      private

      ##
      # Get volume percent
      #
      # @return Integer
      #
      def volume_percent(value)
        value * 100 / MAX_VALUE
      end

      ##
      # Set cards data such as default sink
      # volume and if card is muted
      #
      # @param [Hash] args Parameters
      #
      def set_data(args)
        @cards.each do |id, card|
          next if args[1].nil? || !args[1].include?(card['name'])

          case args[0]
          when 'set-default-sink'
            @default_sink_id = id
          when 'set-sink-volume'
            @cards[id]['volume'] = args[2].hex
            @cards[id]['sink'] = args[1]
          when 'set-sink-mute'
            @cards[id]['muted'] = args[2]
          end
        end
      end

      ##
      # Get long name from list-cards command
      #
      def set_long_names
        dump = command(
          "list-cards | grep -e device.string -e 'name:' -e 'card_name'"
        )
               .split('name: ')
               .reject { |x| x.strip.empty? }

        dump.each do |card|
          id = nil
          name = nil
          card.lines.each do |line|
            args = line.strip.split(' = ')
            if args[0] == 'device.string'
              id = args[1].delete('"').to_i
            elsif args[0] == 'alsa.card_name'
              name = args[1].delete('"')
            end
          end

          @cards[id]['long_name'] = name
        end
      end

      ##
      # Get current sink
      #
      # @return [Hash]
      #
      def current_sink
        @cards[@default_sink_id]
      end

      ##
      # Set up volume
      #
      # @param [Integer] volume Volume to set up, must be a percentage
      #
      def set_volume(volume)
        return if current_sink.nil?

        volume = [[0, (volume * MAX_VALUE / 100)].max, MAX_VALUE].min
        @cards[@default_sink_id]['volume'] = volume
        sink = @cards[@default_sink_id]['sink']
        command("set-sink-volume #{sink} #{format('0x%<v>x', v: volume)}")
      end

      ##
      # Run command
      #
      # @param [String] cmd Command to run
      #
      def command(cmd)
        command = "pacmd #{cmd}"
        result = Mixlib::ShellOut.new(command)
        Volay::Config.logger.debug(command)
        result.run_command

        return unless result.exitstatus.zero?

        Volay::Config.logger.error(result.stderr) unless result.stderr.empty?
        Volay::Config.logger.debug(result.stdout) unless result.stdout.empty?
        result.stdout
      end
    end
  end
end
