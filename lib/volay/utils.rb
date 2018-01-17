# frozen_string_literal: true

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
      return 'volume-muted' if @app.mixer.muted?
      if (66..100).cover?(@app.mixer.percent)
        'volume-high'
      elsif (33..65).cover?(@app.mixer.percent)
        'volume-medium'
      else
        'volume-low'
      end
    end
  end
end
