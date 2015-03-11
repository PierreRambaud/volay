# Volay module
module Volay
  # Widgets components
  module Widget
    # Events class
    class VolumeControl < Events
      ##
      # When volume_scalle is realized
      #
      def on_volume_scale_realize
        @app.get_object('volume_adjustement')
          .value = @app.mixer.percent
      end

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
      def on_toggle_mute_toggled
        Thread.new do
          @app.mixer.toggle
          @app.utils.update_status_icon
        end
      end
    end
  end
end
