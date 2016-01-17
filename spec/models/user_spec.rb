require 'rails_helper'

RSpec.describe User, type: :model do
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
    
  it { should validate_length_of(:name).is_at_least(5).is_at_most(50) }
  it { should validate_length_of(:email).is_at_most(100) }
  
  context 'valid' do
    subject { User.new(name: "Example User", email: "user@example.com") }
    

    
  end
  
end