require 'spec_helper'
require 'volay/utils'

describe 'Volay::Utils' do
  context 'status_icon' do
    def prepare(image, muted, volume_percent)
      app = double
      toggle_image = double
      toggle_button = double
      status_icon = double
      mixer = double
      allow(app).to receive(:mixer).and_return(mixer)
      allow(app).to receive(:get_object)
        .with('status_icon').and_return(status_icon)
      allow(app).to receive(:get_object)
        .with('toggle_mute_image').and_return(toggle_image)
      allow(app).to receive(:get_object)
        .with('toggle_mute').and_return(toggle_button)
      allow(toggle_button).to receive(:set_active).and_return(muted)
      allow(mixer).to receive(:muted?)
        .and_return(muted)
      allow(mixer).to receive(:percent)
        .and_return(volume_percent)
      [status_icon, toggle_image].each do |element|
        allow(element).to receive(:set_stock)
          .with(image).once.and_return(true)
      end

      app
    end

    it 'should change icon to low' do
      app = prepare('volume-low', false, 20)
      utils = Volay::Utils.new(app)
      expect(utils.update_status_icon).to be_truthy
    end

    it 'should change icon to medium' do
      app = prepare('volume-medium', false, 40)
      utils = Volay::Utils.new(app)
      expect(utils.update_status_icon).to be_truthy
    end

    it 'should change icon to high' do
      app = prepare('volume-high', false, 80)
      utils = Volay::Utils.new(app)
      expect(utils.update_status_icon).to be_truthy
    end

    it 'should change icon to muted' do
      app = prepare('volume-muted', true, 0)
      utils = Volay::Utils.new(app)
      expect(utils.update_status_icon).to be_truthy
    end
  end
end
