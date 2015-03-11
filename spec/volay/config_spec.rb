require 'spec_helper'
require 'logger'
require 'volay/config'

describe 'Volay::Config' do
  it 'should return config directory' do
    config_dir = Volay::Config.config_dir
    expect(config_dir).to be_a(String)
    expect(config_dir).to match(/.config\/volay$/)
  end

  it 'should return config file' do
    config_dir = Volay::Config.config_file
    expect(config_dir).to be_a(String)
    expect(config_dir).to match(%r{.config/volay/config$})
  end

  it 'should return logger' do
    expect(Volay::Config.logger).to be_a(Logger)
  end
end
