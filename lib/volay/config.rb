# Volay module
module Volay
  # Config class
  class Config
    attr_reader :logger
    attr_reader :options

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
  end
end
