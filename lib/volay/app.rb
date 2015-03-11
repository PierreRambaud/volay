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

    ##
    # Cross-platform way of finding an executable in the $PATH.
    #
    # Example:
    #   which('ruby') #=> /usr/bin/ruby
    #   which('foo') #=> nil
    #
    # @param [String] cmd Which command
    # @return [String|NilClass]
    #
    def which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        end
      end

      nil
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
      @mixer ||= begin
                   if which('amixer')
                     Volay::Mixer::Alsa.new
                   else
                     fail MixerNotFound
                   end
                 end
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
               File.expand_path('../../glade/icons',
                                File.dirname(__FILE__)))
      add_from_string(ui)
    end
  end
end
