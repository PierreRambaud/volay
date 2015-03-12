require 'spec_helper'
require 'fakefs/spec_helpers'
require 'gtk3'
require 'volay/app'
require 'volay/utils'
require 'volay/widget/events'
require 'volay/widget/system_tray'
require 'volay/widget/volume_control'
require 'volay/mixer/default'
require 'volay/mixer/alsa'
require 'volay/exceptions'

describe 'Volay::App' do
  include FakeFS::SpecHelpers

  context '#which' do
    let(:app) do
      allow_any_instance_of(Volay::App).to receive(:initialize_mixer)
      allow_any_instance_of(Volay::App).to receive(:initialize_events)
      allow_any_instance_of(Volay::App).to receive(:initialize_ui)

      File.write('something', '')
      FileUtils.mkdir_p('/usr/bin')
      File.write('/usr/bin/ruby', '')
      File.chmod(0777, '/usr/bin/ruby')
      Volay::App.new('something')
    end

    it 'should find ruby executable' do
      expect(app.which('ruby')).to eq('/usr/bin/ruby')
    end

    it "shouldn't find amixer executable" do
      expect(app.which('amixer')).to be_nil
    end
  end

  context '#mixer' do
    def app_mixer(prog)
      allow_any_instance_of(Volay::App).to receive(:initialize_events)
      allow_any_instance_of(Volay::App).to receive(:initialize_ui)

      File.write('something', '')
      FileUtils.mkdir_p('/usr/bin')
      File.write("/usr/bin/#{prog}", '')
      File.chmod(0777, "/usr/bin/#{prog}")
      Volay::App.new('something')
    end

    it 'should return alsa' do
      expect(app_mixer('amixer').mixer).to be_a(Volay::Mixer::Alsa)
    end

    it 'should not return pulseaudio' do
      expect { app_mixer('pulseaudio-ctl').mixer }
        .to raise_error(Volay::MixerNotFound)
    end
  end

  context '#events' do
    def app_events
    end

    it 'should return alsa' do
      allow_any_instance_of(Volay::App).to receive(:initialize_mixer)
      allow_any_instance_of(Volay::App).to receive(:initialize_ui)
      allow_any_instance_of(Volay::Utils).to receive(:update_status_icon)
      allow_any_instance_of(Volay::App).to receive(:connect_signals)
        .and_yield('on_status_icon_button_press_event')

      File.write('something', '')
      app = Volay::App.new('something')
      expect(app.signals_list).to be_a(Hash)
    end
  end

  context '#ui' do
    it 'should return alsa' do
      allow_any_instance_of(Volay::App).to receive(:initialize_mixer)
      allow_any_instance_of(Volay::App).to receive(:initialize_events)

      xml = <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<!-- Generated with glade 3.18.3 -->
<interface>
  <requires lib="gtk+" version="3.2"/>
  <object class="GtkIconFactory" id="icon_factory">
    <sources>
  <source stock-id="volume-muted" filename="/glade/icons/volume-muted.png"/>
    </sources>
  </object>
</interface>
EOF

      File.write('something', xml)
      app = Volay::App.new('something')
      expect(app.get_object('icon_factory')).to be_a(Gtk::IconFactory)
    end
  end
end
