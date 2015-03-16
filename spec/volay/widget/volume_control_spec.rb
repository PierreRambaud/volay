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
    Volay::Widget::VolumeControl.new(app)
  end

  it 'on volume scale' do
    utils = double
    volume = double
    allow(volume).to receive(:value=).and_return(20)
    allow(app).to receive(:get_object).once.with('volume_adjustement')
      .and_return(volume)
    allow(app).to receive(:utils).once.and_return(utils)
    allow(utils).to receive(:update_status_icon).once.and_return(true)
    allow(app.mixer).to receive(:percent).and_return(20)
    expect(vc.on_system_tray_window_show).to be_truthy
  end
end
