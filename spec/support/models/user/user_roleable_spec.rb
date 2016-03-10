RSpec.shared_examples "user roleable" do

  context 'regular user' do
    subject{ build(:user) }
    
    it 'should be regular user' do
      expect(subject.regular?).to be true
      expect(subject.staff_member?).to be false
    end
  end
  
  context 'admin user' do
    subject{ build(:admin) }
    
    it 'should be staff member user' do
      expect(subject.regular?).to be false
      expect(subject.staff_member?).to be true
    end
    
  end
  
  it 'should set/unset admin  permission' do
    expect(subject.admin?).to be false
    
    subject.grant_admin!
    
    expect(subject.admin?).to be true
    
    subject.revoke_admin!
    
    expect(subject.admin?).to be false
    
  end
  
end