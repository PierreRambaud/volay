# frozen_string_literal: true

require 'spec_helper'
require 'fakefs/spec_helpers'
require 'gtk3'
require 'volay/app'
require 'volay/utils'
require 'volay/widget/events'
require 'volay/widget/system_tray'
require 'volay/widget/volume_control'
require 'volay/mixer/default'
require 'volay/mixer/pulse'
require 'volay/exceptions'

describe 'Volay::App' do
  include FakeFS::SpecHelpers

  context '#events' do
    let(:popup_menu_cards) do
      pmc = double
      allow(pmc).to receive(:visible=).and_return(true)

      pmc
    end

    it 'should initiliaze events' do
      allow_any_instance_of(Volay::App).to receive(:initialize_mixer)
      allow_any_instance_of(Volay::App).to receive(:initialize_ui)
      allow_any_instance_of(Volay::Utils).to receive(:update_status_icon)
      allow_any_instance_of(Volay::App).to receive(:connect_signals)
        .and_yield('on_status_icon_button_press_event')
      allow_any_instance_of(Volay::App).to receive(:get_object)
        .with('popup_menu_cards')
        .and_return(popup_menu_cards)

      File.write('something', '')
      app = Volay::App.new('something')

      expect(app.signals_list).to be_a(Hash)
    end
  end

  context '#ui' do
    it 'should initialize events' do
      allow_any_instance_of(Volay::App).to receive(:initialize_mixer)
      allow_any_instance_of(Volay::App).to receive(:initialize_events)

      xml = <<-XML
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
      XML

      File.write('something', xml)
      app = Volay::App.new('something')
      expect(app.get_object('icon_factory')).to be_a(Gtk::IconFactory)
    end
  end
end
