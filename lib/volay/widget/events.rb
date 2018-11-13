# frozen_string_literal: true

# Volay module
module Volay
  # Widgets components
  module Widget
    # Events class
    class Events
      attr_reader :app

      ##
      # Initialize signals events
      #
      def initialize(app)
        @app = app

        methods.each do |name|
          next unless name =~ /^on_/

          @app.signals_list[name.to_s] = method(name)
        end

        init if respond_to?('init')
      end
    end
  end
end
