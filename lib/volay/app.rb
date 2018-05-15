# frozen_string_literal: true

# Volay module
module Volay
  # App class
  class App < Gtk::Builder
    attr_accessor :signals_list
    attr_reader :mixer, :utils

    ##
    # Initialize application
    #
    # @param [String] path Path to glade file
    #
    def initialize(path)
      super()

      Gtk::Settings.default.gtk_button_images = true

      initialize_ui(path)
      initialize_mixer
      initialize_events
    end

    private

    ##
    # Initialize events
    #
    def initialize_events
      @signals_list = {}
      @utils = Volay::Utils.new(self)
      @utils.update_status_icon
      Volay::Widget::SystemTray.new(self)
      Volay::Widget::VolumeControl.new(self)

      connect_signals do |handler|
        @signals_list[handler] if @signals_list.key?(handler)
      end
    end

    ##
    # Initialize mixer for controlling volume
    #
    def initialize_mixer
      @mixer ||= Volay::Config.mixer
    end

    ##
    # Intiailize ui by overriding icons path
    #
    # @param [String] path Path to glade file
    #
    def initialize_ui(path)
      # Override Icon path to prevent
      # Gtk-CRITICAL **:gtk_icon_source_set_filename:
      ui = File.read(path)
      ui.gsub!(%r{/glade/icons},
               File.expand_path('../glade/icons',
                                File.dirname(__dir__)))
      add_from_string(ui)
    end
  end
end
