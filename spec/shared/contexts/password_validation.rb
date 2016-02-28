RSpec.shared_context "password validation" do |attribute|
  #invalid_emails = IO.read(Rails.root.join("spec", "fixtures", "lists", "emails_invalid.txt")).lines

  let(:attribute) { attribute }

  def assert_invalid(password)
    eval "subject.#{attribute} = '#{password.strip}'"
    eval "subject.#{attribute}_confirmation = '#{password.strip}'"
    
    subject.valid?
       
    expect(subject.errors).to have_key(attribute.to_sym)
    expect(CommonPasswords.include?(password.strip)).to be true
  end
  
  invalid_passwords = IO.read(Rails.root.join("spec", "fixtures", "lists", "passwords_invalid.txt")).lines
  
  invalid_passwords.each do | password |
    it 'should not accept too common passwords' do 
      assert_invalid(password)
    end
  end
  
end