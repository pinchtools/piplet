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
  
  include_examples 'loggable'
  include_examples 'user roleable'
  include_examples 'user moderatable'
  
  it { should have_many(:logs).dependent(:destroy) }
  it { should have_many(:notifications).dependent(:destroy) }

  it { should have_and_belong_to_many(:filters).class_name('UserFilter') }
    
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:creation_ip_address) }
    
  it { should have_secure_password }
     
  it { should validate_uniqueness_of(:username).case_insensitive }
  it { should validate_uniqueness_of(:email).case_insensitive }
    
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
    Setting.defaults['user.signaled_matching_with_blocked_account'] = true
    Setting.defaults['user.considered_email_similar_when_x_characters'] = 2
    
    subject.email = "mail-similar@example.com"
    
    another_user = create(:user)
    another_user.update_column(:email, "mail-similar1@example.com")

    another_user.block

    expect(subject.find_email_similar_on_scope(:all_blocked)).to eq(another_user.email)

    another_user.update_column(:email, "mail-not-similar-at-all@example.com")

    expect(subject.find_email_similar_on_scope(:all_blocked)).to be_nil
  end
  
  it 'should not have a username similar to a blocked one' do
    Setting.defaults['user.signaled_matching_with_blocked_account'] = true
    Setting.defaults['user.considered_username_similar_when_x_characters'] = 2
    
    subject.username = "very-common"
    
    another_user = create(:user)
    another_user.update_column(:username, "very-common1")
    
    another_user.block
    
    expect(subject.find_username_similar_on_scope(:all_blocked)).to eq(another_user.username)
    
    another_user.update_column(:username, "unusual")
    
    expect(subject.find_username_similar_on_scope(:all_blocked)).to be_nil
  end
  
  it 'should not have a mail similar to a suspected one' do
    Setting.defaults['user.signaled_matching_with_suspected_account'] = true
    Setting.defaults['user.considered_email_similar_when_x_characters'] = 2
    
    subject.email = "mail-similar@example.com"
    
    another_user = create(:user)
    another_user.update_column(:email, "mail-similar1@example.com")

    another_user.suspect
    
    expect(subject.find_email_similar_on_scope(:suspects)).to eq(another_user.email)
    
    another_user.update_column(:email, "mail-not-similar-at-all@example.com")

    expect(subject.find_email_similar_on_scope(:suspects)).to be_nil
  end
  
  it 'should not have a username similar to a suspeced one' do
    Setting.defaults['user.signaled_matching_with_suspected_account'] = true
    Setting.defaults['user.considered_username_similar_when_x_characters'] = 2
    
    subject.username = "very-common"
    
    another_user = create(:user)
    another_user.update_column(:username, "very-common1")
    
    another_user.suspect
    
    expect(subject.find_username_similar_on_scope(:suspects)).to eq(another_user.username)
    
    another_user.update_column(:username, "unusual")
    
    expect(subject.find_username_similar_on_scope(:suspects)).to be_nil
  end
  
  it 'should check a newly created account' do
    expect(subject).to receive(:delay).and_return(subject)
    expect(subject).to receive(:check_new_account)
    
    subject.save
  end
  
  it 'should have a last_seen_at after a creation' do
    expect(subject.last_seen_at).to be_nil
    
    subject.save
    
    expect(subject.last_seen_at).to be_present
  end
  
  it 'should not save last_seen_at when it has  already saved lesser than 1 minute ago' do
    expect(subject.last_seen_at).to be_nil
    
    subject.save
    
    expect(subject.last_seen_at).to be_present
    
    last_seen = subject.last_seen_at
    
    subject.update_last_seen!(last_seen + 30.seconds)
    
    expect(subject.last_seen_at).to eq last_seen
    
    subject.update_last_seen!(last_seen + 1.minute)
     
    expect(subject.last_seen_at).to eq last_seen + 1.minute
  end
  
  it 'generates a default avatar on creation' do
    subject.save
    
    expect(subject.avatar).to be_present
    expect(subject.avatar).to be_default
  end
  

  it 'increments renew countdown when username is update' do
    expect(subject.username_renew_count).to eq(0)
    expect(subject.username).to be_present
    
    subject.save
    
    subject.username += "a"
    
    subject.save
    
    expect(subject.username_renew_count).to eq(1)
  end
  
  it 'send a notification when username is renew' do
    expect(subject.username_renew_count).to eq(0)
    expect(subject.username).to be_present
    
    subject.save
    
    subject.username += "a"
    
    expect(Notification).to receive(:send_to)
    
    subject.save
    
  end
  
  it 'doesn\'t count an username renewal  after a creation' do
    expect(subject.username_renew_count).to eq(0)
    expect(subject.username).to be_present
    
    subject.save
    
    expect(subject.username_renew_count).to eq(0)
  end
  
  it 'blocks username update when limit is reach' do
    Setting['user.max_username_renew'] = 2
    
    subject.save # creation
    
    Setting['user.max_username_renew'].times.each do 
      subject.username += "a"
          
      expect(subject.save).to be_truthy
          
    end
    
    subject.username += "a"
    
    expect(subject).not_to be_valid
    expect(subject.errors).to have_key(:username)
      
  end
  
  describe 'all_to_be_deleted scope' do
    before {
      User.all_to_be_deleted.destroy_all
    }
    
    
    it 'includes to_be_deleted users' do
      expect(User.all_to_be_deleted).to be_empty
      
      user = create(:user_to_be_deleted)
      
      expect(user.to_be_deleted).to be_truthy
      expect(user.to_be_deleted_at).to be_present
      
      expect(User.all_to_be_deleted).to be_present
    end
    
    it 'excludes not to_be_deleted users' do
      expect(User.all_to_be_deleted).to be_empty
      
      user = create(:user)
      
      expect(user.to_be_deleted).to be_falsy
      expect(user.to_be_deleted_at).to be_nil
      
      expect(User.all_to_be_deleted).to be_empty
    end
  end
  
  describe 'deletion_ready scope' do
    it 'includes users with past or present to_be_deleted_at date' do
      expect(User.deletion_ready).to be_empty
      
      user = create(:user_to_be_deleted)
      
      expect(user.to_be_deleted).to be_truthy
      expect(user.to_be_deleted_at).to be_present
      expect(user.to_be_deleted_at).to be <= Time.zone.now
      
      expect(User.deletion_ready).to be_present
    end
    
    it 'excludes users with future to_be_deleted_at date' do
      expect(User.deletion_ready).to be_empty
      
      user = create(:user_to_be_deleted)
      
      user.update_column(:to_be_deleted_at, 1.day.from_now)
      
      expect(user.to_be_deleted).to be_truthy
      expect(user.to_be_deleted_at).to be_present
      expect(user.to_be_deleted_at).to be > Time.zone.now
      
      expect(User.deletion_ready).to be_empty
    end

    it 'exclude not to_be_deleted users' do
      expect(User.deletion_ready).to be_empty
      
      user = create(:user)
      
      expect(user.to_be_deleted).to be_falsy
      expect(user.to_be_deleted_at).to be_nil
      
      expect(User.deletion_ready).to be_empty
    end
  end
  
  
  describe 'search' do
    subject { create(:user) }
      
    it 'find a user by ip address' do
      expect(subject.creation_ip_address).to be_present
      
      results = User.search(subject.creation_ip_address.to_s)
      
      expect(results).to include(subject)
    end
    
    
    it 'find a user by username' do
      expect(subject.username).to be_present
      
      results = User.search(subject.username)
      
      expect(results).to include(subject)
    end
    
    
    it 'find a user by email' do
      expect(subject.email).to be_present
      
      results = User.search(subject.email)
      
      expect(results).to include(subject)
    end
    
  end
  
  describe 'removable?' do
    
    it 'should be already deactivate' do
          expect(subject.deactivated?).to be_falsy
          
          expect(subject.removable?).to be_falsy
    end
    
    it 'should be true for user not suspected neither blocked' do
      subject.deactivated = true
      
      expect(subject.suspected?).to be_falsy
      expect(subject.blocked?).to be_falsy
            
      expect(subject.removable?).to be_truthy
    end
    
    it 'should be true for suspected user if conf setting is set to true' do
      subject.deactivated = true
      subject.suspected = true
      
      User.is_suspect_user_removable = true
      
      expect(subject.removable?).to be_truthy
    end
    
    it 'should be false for suspected user if conf setting is set to false' do
      subject.deactivated = true
      subject.suspected = true
      
      User.is_suspect_user_removable = false
      
      expect(subject.removable?).to be_falsy
    end
    
    it 'should be true for blocked user if conf setting is set to true' do
      subject.deactivated = true
      subject.blocked = true
      
      User.is_blocked_user_removable = true
      
      expect(subject.removable?).to be_truthy
    end
    
    it 'should be false for blocked user if conf setting is set to false' do
      subject.deactivated = true
      subject.blocked = true
      
      User.is_blocked_user_removable = false
      
      expect(subject.removable?).to be_falsy
    end
    
  end

  
  describe 'removal' do
    subject { create(:user) }
    
    it 'deactivates' do
      expect(subject.deactivated).to be_falsy
      expect(subject.deactivated_at).to be_nil
      
      subject.deactivate
      
      expect(subject.deactivated).to be_truthy
      expect(subject.deactivated_at).to be_present
    end
      
    
    context 'for not already deactivated user' do
      
      it 'should call delay_destroy' do
        expect(subject).to receive(:delay_destroy)
        
        expect{ subject.destroy }.to_not change(User, :count)
      end
      
      it 'should deactivates user' do
        expect(subject).to receive(:deactivate)
        
        expect{ subject.destroy }.to_not change(User, :count)
      end
    end
    
    context 'for already deactivate user' do
      subject{ create(:user_deactivated)}
        
        it 'should call destroy' do
          expect(subject).not_to receive(:delay_destroy)
          
          # TODO test destroy method and relations deletions apart
          expect{ subject.destroy }.to change(User, :count).by(-1)
        end
    end
    
    context 'for to be deleted user' do
      subject{ create(:user_to_be_deleted)}
        
      it 'should call destroy' do
        # TODO test destroy method and relations deletions apart
        expect(subject).not_to receive(:delay_destroy)
        
        expect{ subject.destroy }.to change(User, :count).by(-1)
      end
    end
    
    
    describe 'for suspected user' do
      subject{ create(:user_suspected)}
      
      context 'when removal is permitted' do
        before {
          User.is_suspect_user_removable = true
        }
        
        it 'should call delay_destroy when not deactivated' do
          expect(subject.deactivated).to be_falsy
          expect(subject.deactivated_at).to be_nil
          
          expect(subject).to receive(:delay_destroy)

          expect{ subject.destroy }.not_to change(User, :count)
        end
        
        it 'should set deleted_at when a delay is set' do
          User.removal_delay_duration = 20
          
          expect(subject.deactivated).to be_falsy
          expect(subject.deactivated_at).to be_nil
          
          expect(subject.to_be_deleted).to be_falsy
          expect(subject.to_be_deleted_at).to be_nil
          
          subject.destroy
          
          expect(subject.to_be_deleted).to be_truthy
          expect(subject.to_be_deleted_at).to be_present
        end
        
        it 'should remove user when already deactivated' do
          subject.deactivate
          
          User.is_suspect_user_removable = true
          
          expect(subject.deactivated).to be_truthy
          expect(subject.deactivated_at).to be_present
          
          expect(subject).not_to receive(:delay_destroy)
          
          expect{ subject.destroy }.to change(User, :count).by(-1)
        end
        
      end
      
      context 'when removals not permitted' do
        before {
          User.is_suspect_user_removable = false
        }
        
        it 'should call delay_destroy when not deactivated' do
          expect(subject.deactivated).to be_falsy
          expect(subject.deactivated_at).to be_nil
          
          expect(subject).to receive(:delay_destroy)
          
          expect{ subject.destroy }.not_to change(User, :count)
        end
        
        it 'should  not set deleted_at even if a delay is set' do
          User.removal_delay_duration = 20
          
          expect(subject.deactivated).to be_falsy
          expect(subject.deactivated_at).to be_nil
          
          expect(subject.to_be_deleted).to be_falsy
          expect(subject.to_be_deleted_at).to be_nil
          
          subject.destroy
          
          expect(subject.to_be_deleted).to be_falsy
          expect(subject.to_be_deleted_at).to be_nil
        end
        
        it 'should do nothing when already deactivated' do
          subject.deactivate
          
          expect(subject).not_to receive(:delay_destroy)

          expect{ subject.destroy }.not_to change(User, :count)
        end

      end
    end
    
    describe 'for blocked user' do
      subject{ create(:user_blocked)}
      before {
        User.is_blocked_user_removable = true
      }
        
      context 'when removal is permitted' do
        
        it 'should call delay_destroy when not deactivated' do
          expect(User.is_blocked_user_removable).to be_truthy
          expect(subject.deactivated).to be_falsy
          expect(subject.deactivated_at).to be_nil
          
          expect(subject).to receive(:delay_destroy)

          expect{ subject.destroy }.not_to change(User, :count)
        end
        
        it 'should set deleted_at when a delay is set' do
          User.removal_delay_duration = 20
          
          expect(subject.deactivated).to be_falsy
          expect(subject.deactivated_at).to be_nil
          
          expect(subject.to_be_deleted).to be_falsy
          expect(subject.to_be_deleted_at).to be_nil
          
          subject.destroy
          
          expect(subject.to_be_deleted).to be_truthy
          expect(subject.to_be_deleted_at).to be_present
        end
        
        it 'should remove user when already deactivated' do
          expect(User.is_blocked_user_removable).to be_truthy
          
          subject.deactivate
          
          expect(subject.deactivated).to be_truthy
          expect(subject.deactivated_at).to be_present
          
          expect(subject).not_to receive(:delay_destroy)
          
          expect{ subject.destroy }.to change(User, :count).by(-1)
        end
      end
      
      context 'when removal is not permitted' do
        before {
          User.is_blocked_user_removable = false
        }
        
        it 'should call delay_destroy when not deactivated' do
          expect(User.is_blocked_user_removable).to be_falsy
          expect(subject.deactivated).to be_falsy
          expect(subject.deactivated_at).to be_nil
          
          expect(subject).to receive(:delay_destroy)

          expect{ subject.destroy }.not_to change(User, :count)
        end
        
        
        it 'should  not set deleted_at even if a delay is set' do
          User.removal_delay_duration  = 20
          
          expect(subject.deactivated).to be_falsy
          expect(subject.deactivated_at).to be_nil
          
          expect(subject.to_be_deleted).to be_falsy
          expect(subject.to_be_deleted_at).to be_nil
          
          subject.destroy
          
          expect(subject.to_be_deleted).to be_falsy
          expect(subject.to_be_deleted_at).to be_nil
        end
        
        it 'should not do anything when already deactivated' do
          subject.deactivate
          
          #this case should never happened
          expect(subject).not_to receive(:delay_destroy)

          expect{ subject.destroy }.not_to change(User, :count)
        end
        
      end
    end
    
    

   
  end
  
  describe "revert removal" do
    
    context "when use is deactivate" do
      subject { create(:user_deactivated) }
        
      it 'correctly revert deactivation' do
        expect(subject.deactivated).to be_truthy
        expect(subject.deactivated_at).to be_present
        expect(subject.to_be_deleted).to be_falsy
        expect(subject.to_be_deleted_at).to be_nil
        
        expect(subject).to receive(:log)
        
        
        subject.revert_removal
        
        expect(subject.deactivated).to be_falsy
        expect(subject.deactivated_at).to be_nil
        expect(subject.to_be_deleted).to be_falsy
        expect(subject.to_be_deleted_at).to be_nil
      end
    end
    
    context "when use will be deleted" do
      subject { create(:user_to_be_deleted) }
        
      it 'correctly revert deletion' do
        expect(subject.deactivated).to be_truthy
        expect(subject.deactivated_at).to be_present
        expect(subject.to_be_deleted).to be_truthy
        expect(subject.to_be_deleted_at).to be_present
        
        expect(subject).to receive(:log)

        subject.revert_removal
        
        expect(subject.deactivated).to be_falsy
        expect(subject.deactivated_at).to be_nil
        expect(subject.to_be_deleted).to be_falsy
        expect(subject.to_be_deleted_at).to be_nil
        
      end
    end
    
  end
  
end
