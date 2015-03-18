require 'spec_helper'
require 'logger'
require 'volay/config'
require 'volay/mixer/default'
require 'volay/mixer/alsa'
require 'volay/exceptions'

describe 'Volay::Config' do
  include FakeFS::SpecHelpers

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

  context '#which' do
    let(:config) do
      FileUtils.mkdir_p('/usr/bin')
      File.write('/usr/bin/ruby', '')
      File.chmod(0777, '/usr/bin/ruby')
    end

    it 'should find ruby executable' do
      config
      expect(Volay::Config.which('ruby')).to eq('/usr/bin/ruby')
    end

    it "shouldn't find amixer executable" do
      config
      expect(Volay::Config.which('amixer')).to be_nil
    end
  end

  context '#mixer' do
    def app_mixer(prog)
      FileUtils.mkdir_p('/usr/bin')
      File.write("/usr/bin/#{prog}", '')
      File.chmod(0777, "/usr/bin/#{prog}")
    end

    it 'should not return pulseaudio' do
      app_mixer('pulseaudio-ctl')
      expect { Volay::Config.mixer }
        .to raise_error(Volay::MixerNotFound)
    end

    it 'should return alsa' do
      app_mixer('amixer')
      expect(Volay::Config.mixer).to be_a(Volay::Mixer::Alsa)
    end
  end
end
