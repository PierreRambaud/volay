# frozen_string_literal: true

require 'spec_helper'
require 'volay/widget/volume_control'

describe 'Volay::Widget::VolumeControl' do
  let(:app) do
    app = double
    allow(app).to receive(:mixer).and_return(double)
    allow(app).to receive(:signals_list).and_return({})
    app
  end

  let(:vc) do
    allow(Thread).to receive(:new).and_yield
    Volay::Widget::VolumeControl.new(app)
  end

  it 'on volume scale' do
    utils = double
    volume = double

    allow(volume).to receive(:value).once.and_return(20)
    allow(utils).to receive(:update_status_icon).once.and_return(true)

    allow(app).to receive(:utils).once.and_return(utils)
    allow(app.mixer).to receive(:value=).with(20).once

    vc.on_volume_adjustement_value_changed(volume)
  end

  it 'no volume mute' do
    utils = double
    allow(app).to receive(:utils).once.and_return(utils)
    allow(utils).to receive(:update_status_icon).once.and_return(true)
  end
end
