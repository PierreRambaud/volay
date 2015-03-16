# Volay module
module Volay
  # Widgets components
  module Widget
    # Events class
    class VolumeControl < Events
      ##
      # When system tray window is showed
      #
      def on_system_tray_window_show
        @app.get_object('volume_adjustement')
          .value = @app.mixer.percent
        @app.utils.update_status_icon
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
