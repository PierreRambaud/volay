# Volay module
module Volay
  # Mixer module
  module Mixer
    # Default class
    class Default
      ##
      # Up the volume
      #
      def up(*)
        fail NotImplementedError
      end

      ##
      # Down the volume
      #
      def down(*)
        fail NotImplementedError
      end

      ##
      # Set the volume
      #
      def value=(*)
        fail NotImplementedError
      end

      ##
      # Toggle mute
      #
      def toggle
        fail NotImplementedError
      end

      ##
      # Current data, value, max_value,
      # percent and muted
      #
      def current
        fail NotImplementedError
      end

      ##
      # Current value
      #
      def max_value
        current[:value]
      end

      ##
      # Current value
      #
      def value
        current[:value]
      end

      ##
      # Current percent
      #
      def percent
        current[:percent]
      end

      ##
      # Is muted
      #
      def muted?
        current[:muted]
      end
    end
  end
end
