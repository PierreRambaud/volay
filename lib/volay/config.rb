# Volay module
module Volay
  # Config class
  class Config
    attr_reader :logger

    ##
    # Get config directory
    #
    # @return [String]
    #
    def self.config_dir
      File.expand_path('~/.config/volay')
    end

    ##
    # Get config file
    #
    # @return [String]
    #
    def self.config_file
      File.join(config_dir, 'config')
    end

    ##
    # Get logger
    #
    # @return [Logger]
    #
    def self.logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
