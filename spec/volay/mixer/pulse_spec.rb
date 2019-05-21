# frozen_string_literal: true

require 'spec_helper'
require 'mixlib/shellout'
require 'volay/mixer/default'

describe 'Volay::Mixer::Pulse' do
  let(:mixer) do
    Volay::Mixer::Pulse.new
  end

  def stub_shellout(cmd, stdout = '', stderr = '')
    shellout = double(
      error!: nil,
      stdout: stdout,
      stderr: stderr,
      exitstatus: double(
        zero?: true
      )
    )

    allow(shellout).to receive(:run_command)
      .once

    expect(Mixlib::ShellOut).to receive(:new)
      .with("pacmd #{cmd}")
      .and_return(shellout)
  end

  before(:each) do
    stub_shellout(
      'dump',
      File.read(
        File.expand_path('stubs/pulse_dump.stub', __dir__)
      )
    )
    stub_shellout(
      "list-cards | grep -e device.string -e 'name:' -e 'card_name'",
      File.read(
        File.expand_path('stubs/pulse_list-cards.stub', __dir__)
      )
    )
  end

  it 'should raise error when calling up' do
    stub_shellout(
      'set-sink-volume alsa_output.pci-0000_01_00.1.hdmi-stereo 0x10000',
      'Yes'
    )
    expect(mixer.up).to eq('Yes')
  end

  it 'should raise error when calling down' do
    stub_shellout(
      'set-sink-volume alsa_output.pci-0000_01_00.1.hdmi-stereo 0xfae1',
      'Yes'
    )
    expect(mixer.down).to eq('Yes')
  end

  it 'should raise error when calling value=' do
    stub_shellout(
      'set-sink-volume alsa_output.pci-0000_01_00.1.hdmi-stereo 0x8000',
      'Yes'
    )
    expect(mixer.value = '50').to eq('50')
  end

  it 'should raise error when calling toggle' do
    stub_shellout(
      'set-sink-mute alsa_output.pci-0000_01_00.1.hdmi-stereo yes',
      'Yes'
    )
    expect(mixer.toggle).to eq('Yes')
  end

  it 'should raise error when calling current' do
    expect(mixer.current).to eq(value: 65_536,
                                max_value: 65_536,
                                percent: 100,
                                muted: false)
  end
end
