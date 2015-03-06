module Volay
  # Widgets components
  module Widget
    # Events class
    class SystemTray < Events
      LEFT_CLICK = 1
      RIGHT_CLICK = 3

      def on_status_icon_button_press_event(widget, event)
        return unless event.is_a?(Gdk::EventButton) &&
          event.button == LEFT_CLICK
        window = @app.get_object('system_tray_window')
        posx, posy = get_position(window)
        window.move(posx, posy)
        @app.get_object('system_tray_window').show_all
      end

      def on_system_tray_window_focus_out_event
        @app.get_object('system_tray_window').hide
      end

      def on_status_icon_popup_menu(widget, event, time)
        popup_menu = @app.get_object('popup_menu')
        popup_menu.show_all
        popup_menu.popup(nil, nil, 0, time)
      end

      def on_volume_adjustement_value_changed
      end

      def on_popup_menu_quit_activate
        Gtk.main_quit
      end

      def get_position(window)
        screen, rectangle, orientation = @app.get_object('status_icon').geometry
        window.set_screen(screen)
        monitor_num = screen.get_monitor_at_point(rectangle.x, rectangle.y)
        monitor = screen.get_monitor_geometry(monitor_num)
        window_width, window_height = window.size

        if orientation == Gtk::Orientation::VERTICAL
          if monitor.width - rectangle.x == rectangle.width
            # right panel
            posx = monitor.x + monitor.width - window_width - rectangle.width
          else
            # left panel
            posx = rectangle.x + rectangle.width
            posy = rectangle.y
          end
        else
          if (rectangle.y + rectangle.height + window_height <= monitor.y + monitor.height)
            posy = rectangle.y + rectangle.height
          else
            posy = rectangle.y - window_height
            if (rectangle.x + window_width <= monitor.x + monitor.width)
              posx = rectangle.x
            else
              posx = monitor.x + monitor.width - window_width
            end
          end
        end

        return posx, posy
      end
    end
  end
end
