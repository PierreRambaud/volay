# frozen_string_literal: true

require 'spec_helper'
require 'logger'
require 'volay/config'
require 'volay/mixer/default'
require 'volay/mixer/pulse'
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
      File.chmod(0o777, '/usr/bin/ruby')
    end

    it 'should find ruby executable' do
      config
      expect(Volay::Config.which('ruby')).to eq('/usr/bin/ruby')
    end

    it "shouldn't find pacmd executable" do
      config
      expect(Volay::Config.which('pacmd')).to be_nil
    end
  end

  context '#mixer' do
    def app_mixer(prog)
      FileUtils.mkdir_p('/usr/bin')
      File.write("/usr/bin/#{prog}", '')
      File.chmod(0o777, "/usr/bin/#{prog}")
    end

    it 'should not return pulseaudio' do
      expect { Volay::Config.mixer }
        .to raise_error(Volay::MixerNotFound)
    end

    it 'should return a mixer' do
      Volay::Config.logger.level = :info
      allow_any_instance_of(Mixlib::ShellOut).to receive(:new).twice
      allow_any_instance_of(Mixlib::ShellOut).to receive(:run_command)
      app_mixer('pacmd')
      expect(Volay::Config.mixer).to be_a(Volay::Mixer::Pulse)
    end
  end
end
