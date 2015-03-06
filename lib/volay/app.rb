module Volay
  class App < Gtk::Builder
    attr_accessor :signals_list

    def initialize(path)
      super()

      Gtk::Settings.default.gtk_button_images = true
      add_from_file(path)

      @signals_list = {}
      Volay::Widget::SystemTray.new(self)

      connect_signals do |handler|
        @signals_list[handler] if @signals_list.key?(handler)
      end
    end
  end
end
