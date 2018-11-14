# frozen_string_literal: true

require 'spec_helper'
require 'gtk3'
require 'volay/widget/system_tray'

describe 'Volay::Widget::SystemTray' do
  let(:mixer) do
    m = double
    allow(m).to receive(:cards).and_return({})

    m
  end

  let(:popup_menu_cards) do
    pmc = double
    allow(pmc).to receive(:visible=).and_return(true)

    pmc
  end

  let(:app) do
    app = double
    allow(app).to receive(:mixer).and_return(mixer)
    allow(app).to receive(:signals_list).and_return({})
    allow(app).to receive(:get_object)
      .with('popup_menu_cards')
      .and_return(popup_menu_cards)

    app
  end

  let(:st) do
    allow(Thread).to receive(:new).and_yield
    Volay::Widget::SystemTray.new(app)
  end

  it 'on icon button pressed with wrong event' do
    event = double
    allow(event).to receive(:button)
      .once
      .and_return(
        Volay::Widget::SystemTray::KEYCODE_MOUSE_CLICK_RIGHT
      )

    expect(st.on_status_icon_button_press_event(double, event)).to be_nil
  end

  it 'on icon button pressed with invisible system tray' do
    event = double
    allow(event).to receive(:is_a?)
      .once
      .with(Gdk::EventButton)
      .and_return(true)

    allow(event).to receive(:button)
      .once
      .and_return(
        Volay::Widget::SystemTray::KEYCODE_MOUSE_CLICK_LEFT
      )

    stw = double
    allow(stw).to receive(:visible?).once.and_return(true)
    allow(stw).to receive(:hide).once
    allow(app).to receive(:get_object)
      .with('system_tray_window')
      .twice
      .and_return(stw)

    expect(st.on_status_icon_button_press_event(double, event)).to be_nil
  end
end
