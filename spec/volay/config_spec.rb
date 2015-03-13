require 'spec_helper'
require 'logger'
require 'volay/config'

describe 'Volay::Config' do
  it 'should return config file' do
    config_file = Volay::Config.config_file
    expect(config_file).to be_a(String)
    expect(config_file).to match(/.volay$/)
  end

  it 'should return logger' do
    expect(Volay::Config.logger).to be_a(Logger)
  end

  it 'should set and get config' do
    Volay::Config.set('test', 'something')
    expect(Volay::Config.get('test')).to eq('something')
    expect(Volay::Config.get(:test)).to eq('something')
    expect(Volay::Config.get(:something)).to be_nil
  end
end
