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
        raise NotImplementedError
      end

      ##
      # Down the volume
      #
      def down(*)
        raise NotImplementedError
      end

      ##
      # Set the volume
      #
      def value=(*)
        raise NotImplementedError
      end

      ##
      # Toggle mute
      #
      def toggle
        raise NotImplementedError
      end

      ##
      # Current data, value, max_value,
      # percent and muted
      #
      def current
        raise NotImplementedError
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
