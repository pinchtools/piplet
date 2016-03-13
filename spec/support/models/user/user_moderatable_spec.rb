RSpec.shared_examples "user moderatable" do

  context 'admin user' do
    subject{ create(:admin) }
    before(:each) do
      @user = create(:user)
      @another_admin = create(:admin)
    end
    
    it 'should be able to mark/unmark user as suspect' do
      expect(@user.suspected?).to be false
      expect(@user.suspected_at).to be nil
      expect(@user.suspected_by_id).to be nil
      
      expect(subject.suspect_user(@user)).to be true
      
      expect(@user.suspected?).to be true
      expect(@user.suspected_at).not_to be nil
      expect(@user.suspected_by_id).not_to be nil
      
      expect(subject.clear_suspect(@user)).to be true

      expect(@user.suspected?).to be false
      expect(@user.suspected_at).to be nil
      expect(@user.suspected_by_id).to be nil
    end
    
    it 'can\'t be suspected' do
      expect(@another_admin.suspect_user(subject)).to be false
      expect(subject.suspect).to be false
    end
    
    it 'should be able to block/unblock user' do
        expect(@user.blocked?).to be false
        expect(@user.blocked_at).to be nil
        expect(@user.blocked_by_id).to be nil
        
        expect(subject.block_user(@user)).to be true
        
        expect(@user.blocked?).to be true
        expect(@user.blocked_at).not_to be nil
        expect(@user.blocked_by_id).not_to be nil
        
        expect(subject.unblock_user(@user)).to be true
  
        expect(@user.blocked?).to be false
        expect(@user.blocked_at).to be nil
        expect(@user.blocked_by_id).to be nil
    end
    
    it 'can\'t be suspected' do
      expect(@another_admin.block_user(subject)).to be false
      expect(subject.block).to be false
    end
    
  end

  
  context 'regular user' do
    subject{ create(:user) }
    before{ @admin = create(:admin)}
    before{ @another_user = create(:user)}
    
    it 'can\'t suspect anyone ' do
      expect(subject.suspect_user(@admin)).to be false
      expect(subject.suspect_user(@another_user)).to be false
    end
    
    it 'can be suspected' do
      expect(@admin.suspect_user(subject)).to be true
      expect(subject.suspect).to be true
    end
    
    it 'can\'t block anyone ' do
      expect(subject.block_user(@admin)).to be false
      expect(subject.block_user(@another_user)).to be false
    end
    
    it 'can be blocked' do
      expect(@admin.block_user(subject)).to be true
      expect(subject.block).to be true
    end
    
  end
  
end