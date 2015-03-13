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
    volume = double
    allow(volume).to receive(:value=).and_return(20)
    allow(app).to receive(:get_object).once.with('volume_adjustement')
      .and_return(volume)
    allow(app.mixer).to receive(:percent).and_return(20)
    expect(vc.on_volume_scale_realize).to eq(20)
  end
end
