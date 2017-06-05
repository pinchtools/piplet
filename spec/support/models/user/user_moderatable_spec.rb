RSpec.shared_examples "user moderatable" do

  context 'admin' do
    before(:all) do
      
      
      @admin = build(:admin)
      @user = build(:user)
      @another_admin = build(:admin)
      
      
      @admin.email = "admin-user@example.com"
      @user.email = "regular-user1@example.com"
      @another_admin.email = "admin-user1@example.com"
      
      User.where(email: [@admin.email, @user.email, @another_admin.email ] ).destroy_all
      
      @admin.save
      @user.save
      @another_admin.save
    end
    
    after(:all) do
      User.where(email: [@admin.email, @user.email, @another_admin.email ] ).destroy_all
    end
    
    it 'should be able to mark/unmark user as suspect' do
      expect(@user.suspected?).to be false
      expect(@user.suspected_at).to be nil
      expect(@user.suspected_by_id).to be nil
      
      expect(@admin).to receive(:log)
      expect(@user).to receive(:log)
      
      expect(@admin.suspect_user(@user)).to be true
      
      expect(@user.suspected?).to be true
      expect(@user.suspected_at).not_to be nil
      expect(@user.suspected_by_id).not_to be nil
      
      expect(@admin).to receive(:log)
      expect(@user).to receive(:log)
      
      expect(@admin.trust_user(@user)).to be true

      expect(@user.suspected?).to be false
      expect(@user.suspected_at).to be nil
      expect(@user.suspected_by_id).to be nil
    end
    
    it 'can\'t be suspected' do
      expect(@another_admin.suspect_user(@admin)).to be false
      expect(@admin.suspect).to be false
    end
    
    it 'should be able to block/unblock user' do
        expect(@user.blocked?).to be false
        expect(@user.blocked_at).to be nil
        expect(@user.blocked_by_id).to be nil
        
        expect(@admin).to receive(:log)
        expect(@user).to receive(:log)
        
        expect(@admin.block_user(@user)).to be true
        
        expect(@user.blocked?).to be true
        expect(@user.blocked_at).not_to be nil
        expect(@user.blocked_by_id).not_to be nil
        
        expect(@admin).to receive(:log)
        expect(@user).to receive(:log)
        
        expect(@admin.unblock_user(@user)).to be true
  
        expect(@user.blocked?).to be false
        expect(@user.blocked_at).to be nil
        expect(@user.blocked_by_id).to be nil
    end
    
    it 'can\'t be suspected' do
      expect(@another_admin.block_user(@admin)).to be false
      expect(@admin.block).to be false
    end
    
  end

  
  context 'regular user' do
    before(:all) do
      @user = build(:user)
      @admin = build(:admin)
      @another_user = build(:user)
      
      @user.email = "regular-user2@example.com"
      @admin.email = "admin-user3@example.com"
      @another_user.email = "regular-user3@example.com"
      
      User.where(email: [@user.email, @admin.email, @another_user.email ] ).destroy_all
            
        
      @user.save
      @admin.save
      @another_user.save
    end
    
    after(:all) do
      User.where(email: [@user.email, @admin.email, @another_user.email ] ).destroy_all
    end
    
    
    it 'can\'t suspect anyone ' do
      expect(@user.suspect_user(@admin)).to be false
      expect(@user.suspect_user(@another_user)).to be false
    end
    
    it 'can be suspected' do
      expect(@admin.suspect_user(@user)).to be true
      expect(@user.suspect).to be true
    end
    
    it 'unblock user when suspected' do
      @user.block
      
      expect(@user).to be_blocked
      
      @user.suspect
      
      expect(@user).to_not be_blocked
      
    end
    
    it 'can\'t block anyone' do
      expect(@user.block_user(@admin)).to be false
      expect(@user.block_user(@another_user)).to be false
    end
    
    it 'can be blocked' do
      expect(@admin.block_user(@user)).to be true
      expect(@user.block).to be true
    end
    
    it 'can add a note when blocked' do
      expect(@user.blocked_note).to be_nil
      
      note = 'test'
      
      @user.block(blocked_note: note)
      
      expect(@user.blocked_note).to eq(note)
    end
  
    it 'remove note when unblocked' do
      note = 'test'

      @user.block(blocked_note: note)

      expect(@user.blocked_note).to eq(note)
      
      @user.unblock
      
      expect(@user.blocked_note).to be_nil
    end
    
    it 'can add a note when suspected' do
      expect(@user.suspected_note).to be_nil
      
      note = 'test'
      
      @user.suspect(suspected_note: note)
      
      expect(@user.suspected_note).to eq(note)
    end
    
    it 'remove note when trusted' do
      note = 'test'

      @user.suspect(suspect_note: note)

      expect(@user.suspected_note).to eq(note)
      
      @user.trust
      
      expect(@user.suspected_note).to be_nil
    end
    
    
  end
  
end