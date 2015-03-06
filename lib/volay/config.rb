module Volay
  class Config
    def config_dir
      File.expand_path('~/.config/volay')
    end

    def config_file
      File.join(config_dir, 'config')
    end
  end
end
