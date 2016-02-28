# == Schema Information
#
# Table name: users
#
#  id                :integer          not null, primary key
#  username          :string
#  email             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  password_digest   :string
#  remember_digest   :string
#  admin             :boolean          default(FALSE)
#  activation_digest :string
#  activated         :boolean          default(FALSE)
#  activated_at      :datetime
#  reset_digest      :string
#  reset_sent_at     :datetime
#

require 'rails_helper'
require "shared/contexts/email_validation"
require "shared/contexts/username_validation"
require "shared/contexts/password_validation"

RSpec.describe User, type: :model do
  subject { build(:user) }
  
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should have_secure_password }
     
  it { should validate_uniqueness_of(:username).case_insensitive }
  it { should validate_uniqueness_of(:email).case_insensitive }
    
  it { should validate_length_of(:username).is_at_least(5).is_at_most(50) }
  it { should validate_length_of(:password).is_at_least(6).is_at_most(255) }
  it { should validate_length_of(:email).is_at_most(255) }
  
  it 'shoud be valid' do
    expect(subject.valid?).to be true
  end
  
  context "email validation" do
    include_context "email validation", :email
  end
  
  context "username validation" do
    include_context "username validation", :username
  end
  
  context "password validation" do
    include_context "password validation", :password
  end
  
  it 'should populate username_lower before validation' do
    subject.username = "fOoBar"
    expect(subject.username_lower).to be_nil
    
    subject.valid?
    
    expect(subject.username_lower).to eq(subject.username.downcase)
  end
  
  it 'should saved email in lower-case' do
    email = "UsEr.tEST@EXAmple.com"
    subject.email = email
    subject.save
    
    expect(subject.email).to eq(email.downcase)
  end
  
  it 'should not accept a password equal to username' do
    subject.password = subject.username
    subject.password_confirmation = subject.username
    
    subject.valid?
    
    expect(subject.errors).to have_key(:password)
  end

  it 'should not accept a password equal to email' do
    subject.password = subject.email
    subject.password_confirmation = subject.email
    
    subject.valid?
    
    expect(subject.errors).to have_key(:password)
  end

  it 'authenticated? should return false for a user with nil digest' do
    expect(subject.authenticated?(:remember, '')).to be false
  end
  
  it 'should generate a token when user is remembered' do
    expect{ subject.remember }.to change(subject, :remember_token).to be_present
  end
  
  it 'should set  a digest when user is remembered' do
    expect{ subject.remember }.to change(subject, :remember_digest).to be_present
  end
  
end
