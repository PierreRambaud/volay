# Volay module
module Volay
  # Config class
  class Config
    attr_reader :logger, :mixer, :options

    ##
    # Get option
    #
    # @return [Mixed]
    #
    def self.init_config
      File.write(config_file, '') unless File.exist?(config_file)
      logger.level = get(:log_level)
    end

    ##
    # Get option
    #
    # @return [Mixed]
    #
    def self.get(option)
      @options ||= {}
      @options[option.to_sym] if @options.key?(option.to_sym)
    end

    ##
    # Set option
    #
    # @param [String|Symbol] option Option key
    # @param [Mixed] value Option value
    #
    def self.set(option, value)
      @options ||= {}
      @options[option.to_sym] = value
    end

    ##
    # Get config file
    #
    # @return [String]
    #
    def self.config_file
      File.expand_path('~/.volay')
    end

    ##
    # Get logger
    #
    # @return [Logger]
    #
    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    ##
    # Initialize mixer for controlling volume
    #
    def self.mixer
      @mixer ||= begin
                   if which('amixer')
                     Volay::Mixer::Alsa.new
                   else
                     fail MixerNotFound
                   end
                 end
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
    def self.which(cmd)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        end
      end

      nil
    end
  end
end
