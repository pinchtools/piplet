require 'rails_helper'

describe UsersDecorator do
  let(:users) { [] }
  
  it 'respond to will_paginate methods' do
    expect(UsersDecorator.new(users)).to respond_to(:total_pages)
  end
  
end
