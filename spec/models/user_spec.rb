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
#  username_lower    :string
#

require 'rails_helper'
require "shared/contexts/email_validation"
require "shared/contexts/username_validation"
require "shared/contexts/password_validation"

RSpec.describe User, type: :model do
  
  subject { build(:user) }
  
  include_examples 'user loggable'
  include_examples 'user roleable'
  include_examples 'user moderatable'
  
  it { should have_many(:logs).dependent(:destroy) }
  
  it { should have_and_belong_to_many(:filters).class_name('UserFilter') }
    
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:creation_ip_address) }
    
  it { should have_secure_password }
     
  it { should validate_uniqueness_of(:username).case_insensitive }
  it { should validate_uniqueness_of(:email).case_insensitive }
    
  it { should validate_length_of(:username).is_at_least(5).is_at_most(50) }
  it { should validate_length_of(:password).is_at_least(6).is_at_most(255) }
  it { should validate_length_of(:email).is_at_most(255) }
  
    
  it 'shoud be valid' do
    expect(subject.valid?).to be true
  end
  
  
  it 'should generate a log when saved' do
    expect(subject).to receive(:log)
    subject.save
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
  
  
  describe 'activation' do
    subject{ create(:user) }
    
    it 'should validate presence of activated_at' do
      
      expect(subject).to receive(:log)
      expect( subject ).to validate_presence_of(:activated_at)
      expect( subject ).to validate_presence_of(:activation_ip_address)
      
      subject.activate('126.98.8.123')
    end
  end
  

  it 'should log a creation' do
    expect(subject).to receive(:log)
    
    subject.save
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
  
  
  it 'should not have a mail similar to a blocked one' do
    Setting['user.suspect_email_similar_to_banned_one'] = true
    Setting['user.considered_email_similar_when_x_characters'] = 2
    
    subject.email = "mail-similar@example.com"
    
    another_user = build(:user)
    another_user.email = "mail-similar1@example.com"
    another_user.save
    
    another_user.block
    
    expect(subject.find_email_similar_to_blocked_one).to eq(another_user.email)
    
    
    another_user.email = "mail-not-at-all-similar@example.com"
    another_user.save
    
    expect(subject.find_email_similar_to_blocked_one).to be nil

  end
  
  
  it 'should check a newly created account' do
    expect(subject).to receive(:delay).and_return(subject)
    expect(subject).to receive(:check_new_account)
    
    subject.save
  end
  
  it 'should remove relation with user_filters when destroyed' do
#    filter = create(:user_filter)
#    subject.save
#    subject.filters << filter
#    
#    expect(subject).to have_any(filters)
  end
  
end
