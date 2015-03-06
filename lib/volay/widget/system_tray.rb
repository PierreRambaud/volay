module Volay
  # Widgets components
  module Widget
    # Events class
    class SystemTray < Events
      def on_status_icon_popup_menu
        @app.get_object('popup_menu').show_all
      end

      def on_volume_adjustement_value_changed
      end

      def on_popup_menu_quit_activate
        @app.quit()
      end
    end
  end
end
