# frozen_string_literal: true

require 'spec_helper'
require 'volay/mixer/default'

describe 'Volay::Mixer::Default' do
  let(:mixer) do
    Volay::Mixer::Default.new
  end

  it 'should raise error when calling up' do
    expect { mixer.up }.to raise_error(NotImplementedError)
  end

  it 'should raise error when calling down' do
    expect { mixer.down }.to raise_error(NotImplementedError)
  end

  it 'should raise error when calling value=' do
    expect { mixer.value = '50' }.to raise_error(NotImplementedError)
  end

  it 'should raise error when calling toggle' do
    expect { mixer.toggle }.to raise_error(NotImplementedError)
  end

  it 'should raise error when calling current' do
    expect { mixer.current }.to raise_error(NotImplementedError)
  end

  it 'should raise error when calling value' do
    expect { mixer.value }.to raise_error(NotImplementedError)
  end

  it 'should raise error when calling max_value' do
    expect { mixer.max_value }.to raise_error(NotImplementedError)
  end

  it 'should raise error when calling percent' do
    expect { mixer.percent }.to raise_error(NotImplementedError)
  end

  it 'should raise error when calling muted' do
    expect { mixer.muted? }.to raise_error(NotImplementedError)
  end
end
