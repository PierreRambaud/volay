# frozen_string_literal: true

# Volay module
module Volay
  # Widgets components
  module Widget
    # Events class
    class SystemTray < Events
      KEYCODE_MOUSE_CLICK_LEFT = 1
      KEYCODE_MOUSE_CLICK_RIGHT = 3
      KEYCODE_M = 47

      ##
      # When popup window menu is draw
      #
      def init
        refresh_cards_menu
      end

      ##
      # When left click on the status icon, popup the window menu
      #
      # @param [Gtk::Widget] widget Widget
      # @param [Gtk::Event] event Event
      #
      def on_status_icon_button_press_event(_widget, event)
        return unless event.is_a?(Gdk::EventButton) &&
                      event.button == KEYCODE_MOUSE_CLICK_LEFT

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
      # Check for M keycode to toggle mute
      #
      def on_system_tray_window_key_release_event(_widget, event)
        return unless event.is_a?(Gdk::EventKey) &&
                      event.hardware_keycode == KEYCODE_M

        @app.mixer.toggle
        @app.utils.update_status_icon
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
      # When system tray window is showed
      #
      def on_system_tray_window_show
        @app.mixer.refresh
        refresh_cards_menu

        @app.get_object('volume_adjustement')
            .value = @app.mixer.percent
        @app.utils.update_status_icon
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
        elsif rectangle.y + rectangle.height + window_height <=
              monitor.y + monitor.height
          posy = rectangle.y + rectangle.height
        else
          posy = rectangle.y - window_height
          posx = if rectangle.x + window_width <= monitor.x + monitor.width
                   rectangle.x
                 else
                   monitor.x + monitor.width - window_width
                 end
        end

        [posx, posy]
      end

      private

      ##
      # Refresh card menu items
      #
      def refresh_cards_menu
        @app.get_object('popup_menu_cards').visible = false

        return unless @app&.mixer&.cards
        return if @app.mixer.cards.keys.count <= 1

        menu = Gtk::Menu.new
        last_item = nil
        @app.mixer.cards.each do |id, card|
          radio_menu_item = Gtk::RadioMenuItem.new(nil, card['long_name'])
          radio_menu_item.join_group(last_item) if last_item
          radio_menu_item.name = "card_menu_#{id}"
          radio_menu_item.visible = true
          radio_menu_item.active = @app.mixer.default_sink_id == id
          last_item = radio_menu_item
          menu.append(radio_menu_item)

          radio_menu_item.signal_connect('activate') do |widget|
            next unless widget.active?

            @app.mixer.change_card(id)
            @app.utils.update_status_icon
          end
        end

        @app.get_object('popup_menu_cards').visible = true
        @app.get_object('popup_menu_cards').submenu = menu
      end
    end
  end
end
