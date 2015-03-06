module Volay
  module Controller
    class Alsa
      attr_reader :instance
      attr_reader :control
      attr_reader :card

      def initialize(card, control, instance)
        @instance = instance
        @control = control
        @card = card
      end
    end
  end
end
