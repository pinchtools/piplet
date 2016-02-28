RSpec.shared_context "username validation" do |attribute|

  let(:attribute) { attribute }

  def assert_invalid(username)
    subject[attribute] = username.strip
     
    subject.valid?
  
    expect(subject.errors).to have_key(attribute.to_sym)
  end
  
  
  # username with invalid characters
  invalid_usernames = IO.read(Rails.root.join("spec", "fixtures", "lists", "usernames_invalid.txt")).lines
  
  invalid_usernames.each do | username |
    it 'should not accept username with invalid characters' do 
      assert_invalid(username)
    end
  end
  
end