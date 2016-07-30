RSpec.shared_context "username validation" do |attribute|

  let(:attribute) { attribute }

    
  def assert_invalid(username)
    subject[attribute] = username.strip
     
    subject.valid?
  
    expect(subject.errors).to have_key(attribute.to_sym)
  end
  
  def assert_valid(username)
    subject[attribute] = username.strip

    expect(subject).to be_valid
  end

  
  # username with invalid characters
  invalid_usernames = IO.read(Rails.root.join("spec", "fixtures", "lists", "usernames_invalid.txt")).lines
  
  invalid_usernames.each do | username |
    it 'should not accept invalid username (bad syntax or reserved)' do 
      assert_invalid(username)
    end
  end
  
  it 'should have a length include into an accepted range' do
    username = "u"

    range = User.min_username_characters..User.max_username_characters
    
    assert_invalid(username.ljust(range.first - 1, "z"))
    assert_invalid(username.ljust(range.last + 1, "z"))
    
    range.each do |i|
      assert_valid(username.ljust(i, "z"))
    end
    
  end
  
end