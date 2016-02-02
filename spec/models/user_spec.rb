# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'
require "shared/contexts/email_validation"

RSpec.describe User, type: :model do
  subject { build(:user) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should have_secure_password }
     
  it { should validate_uniqueness_of(:name).case_insensitive }
  it { should validate_uniqueness_of(:email).case_insensitive }
    
  it { should validate_length_of(:name).is_at_least(5).is_at_most(50) }
  it { should validate_length_of(:password).is_at_least(6).is_at_most(255) }
  it { should validate_length_of(:email).is_at_most(255) }
  
  it 'shoud be valid' do
    expect(subject.valid?).to be true
  end
    
  include_context "email validation", :email

  it 'should saved email in lower-case' do
    email = "UsEr.tEST@EXAmple.com"
    subject.email = email
    subject.save
    
    expect(subject.email).to eq(email.downcase)
  end
  
  it 'should save name in lower-case' do
    name = "GoUda"
    subject.name = name
    subject.save
    
    expect(subject.name).to eq(name.downcase)
  end
  
  it 'should generate a token when user is remembered' do
    expect{ subject.remember }.to change(subject, :remember_token).to be_present
  end
  
  it 'should set  a digest when user is remembered' do
    expect{ subject.remember }.to change(subject, :remember_digest).to be_present
  end
  
end