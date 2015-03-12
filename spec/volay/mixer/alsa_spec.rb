require 'spec_helper'
require 'mixlib/shellout'
require 'volay/mixer/default'

describe 'Volay::Mixer::Alsa' do
  let(:mixer) do
    Volay::Mixer::Alsa.new
  end

  def stub_shellout(cmd, stdout = '', stderr = '')
    allow_any_instance_of(Mixlib::ShellOut).to receive(:run_command)
    allow_any_instance_of(Mixlib::ShellOut).to receive(:new)
      .with("amixer #{cmd}")
    allow_any_instance_of(Mixlib::ShellOut).to receive(:stdout)
      .and_return(stdout)
    allow_any_instance_of(Mixlib::ShellOut).to receive(:stderr)
      .and_return(stderr)
  end

  it 'should raise error when calling up' do
    stub_shellout('-q set Master 2%+', 'Yes')
    expect(mixer.up).to eq('Yes')
  end

  it 'should raise error when calling down' do
    stub_shellout('-q set Master 2%-', 'Yes')
    expect(mixer.down).to eq('Yes')
  end

  it 'should raise error when calling value=' do
    stub_shellout('-q set Master 50%', 'Yes')
    expect(mixer.value = '50').to eq('50')
  end

  it 'should raise error when calling toggle' do
    stub_shellout('-q set Master toggle', 'Yes')
    expect(mixer.toggle).to eq('Yes')
  end

  it 'should raise error when calling current' do
    stdout = <<-EOF
Simple mixer control 'Master',0
  Capabilities: pvolume pswitch pswitch-joined
  Playback channels: Front Left - Front Right
  Limits: Playback 0 - 65536
  Mono:
  Front Left: Playback 13108 [20%] [off]
  Front Right: Playback 13108 [20%] [off]
EOF
    stub_shellout('get Master', stdout)
    expect(mixer.current).to eq(value: 13_107,
                                max_value: 65_536,
                                percent: 20,
                                muted: true)
  end
end
