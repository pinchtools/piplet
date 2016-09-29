require 'rails_helper'

describe LogsDecorator do
  let(:logs) { [] }
  
  it 'respond to will_paginate methods' do
    expect(LogsDecorator.new(logs)).to respond_to(:total_pages)
  end
  
end
