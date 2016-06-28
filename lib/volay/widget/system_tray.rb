# Volay module
module Volay
  # Widgets components
  module Widget
    # Events class
    class SystemTray < Events
      LEFT_CLICK = 1
      RIGHT_CLICK = 3

      ##
      # When left click on the status icon, popup the window menu
      #
      # @param [Gtk::Widget] widget Widget
      # @param [Gtk::Event] event Event
      #
      def on_status_icon_button_press_event(_widget, event)
        return unless event.is_a?(Gdk::EventButton) &&
                      event.button == LEFT_CLICK
        return on_system_tray_window_focus_out_event if
          @app.get_object('system_tray_window').visible?

        window = @app.get_object('system_tray_window')
        posx, posy = get_position(window)
        window.move(posx, posy)
        @app.get_object('system_tray_window').show_all
      end

      ##
      # When click outside the window
      #
      def on_system_tray_window_focus_out_event
        @app.get_object('system_tray_window').hide
      end

      ##
      # When right click on the status icon
      #
      # @param [Gtk::Widget] widget Widget
      # @param [Gtk::Event] event Event
      # @param [Integer] time Time
      def on_status_icon_popup_menu(_widget, _event, time)
        popup_menu = @app.get_object('popup_menu')
        popup_menu.show_all
        popup_menu.popup(nil, nil, 0, time)
      end

      ##
      # When quit button is clicked
      #
      def on_popup_menu_quit_activate
        Gtk.main_quit
      end

      ##
      # Retrieve the good position to be above
      # the status icon
      #
      # @param [Gtk::Window] window Window
      #
      def get_position(window)
        _e, screen, rectangle, orientation = @app.get_object('status_icon')
                                                 .geometry
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
          total = rectangle.y + rectangle.height + window_height
          if total <= monitor.y + monitor.height
            posy = rectangle.y + rectangle.height
          else
            posy = rectangle.y - window_height
            posx = if rectangle.x + window_width <= monitor.x + monitor.width
                     rectangle.x
                   else
                     monitor.x + monitor.width - window_width
                   end
          end
        end

        [posx, posy]
      end
    end
  end
end
