# frozen_string_literal: true

# Volay module
module Volay
  # Widgets components
  module Widget
    # Events class
    class VolumeControl < Events
      ##
      # When slider have its adjustement value changed
      #
      def on_volume_adjustement_value_changed(widget)
        Thread.new do
          @app.mixer.value = widget.value
          @app.utils.update_status_icon
        end
      end

      ##
      # When mute toggle image is clicked
      #
      def on_toggle_mute_toggled(widget)
        Thread.new do
          @app.mixer.toggle unless (widget.active? && @app.mixer.muted?) ||
                                   (!widget.active? && !@app.mixer.muted?)
          @app.utils.update_status_icon
        end
      end
    end
  end
end
