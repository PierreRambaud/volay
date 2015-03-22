# Volay module
module Volay
  # Utils class
  class Utils
    attr_reader :app

    ##
    # Initialize utils class
    #
    # @param [Gtk::Builder] app Application
    #
    def initialize(app)
      @app = app
    end

    ##
    # Change status icon stock
    #
    def update_status_icon
      icon = status_icon
      @app.get_object('status_icon')
        .set_stock(icon)
      @app.get_object('toggle_mute').set_active(@app.mixer.muted?)
      @app.get_object('toggle_mute_image')
        .set_stock(icon)
    end

    def status_icon
      case @app.mixer.percent
      when 66..100
        icon = 'volume-high'
      when 33..65
        icon = 'volume-medium'
      when 0..32
        icon = 'volume-low'
      end unless @app.mixer.muted?

      icon.nil? ? 'volume-muted' : icon
    end
  end
end
