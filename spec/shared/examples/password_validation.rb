require_dependency "common_passwords"

RSpec.shared_examples "password validation" do |attribute|
  let(:attribute) { attribute }
  let(:invalid_passwords) { IO.read(Rails.root.join("spec", "fixtures", "lists", "passwords_invalid.txt")).lines }

  def assert_invalid(password)
    eval "subject.#{attribute} = '#{password.strip}'"
    eval "subject.#{attribute}_confirmation = '#{password.strip}'"

    expect(subject).not_to be_valid
    expect(subject.errors).to have_key(attribute.to_sym)
  end
  
  
  def assert_valid(password)
    eval "subject.#{attribute} = '#{password.strip}'"
    eval "subject.#{attribute}_confirmation = '#{password.strip}'"

    expect(subject).to be_valid
  end

  it 'should not accept too common passwords' do
    invalid_passwords.each do | password |
      assert_invalid(password)
    end
  end

  it 'should have a length include into an accepted range' do
    password = "R0d"
    range = User.min_password_characters..User.max_password_characters
    
    assert_invalid(password.ljust(range.first - 1, "z"))
    assert_invalid(password.ljust(range.last + 1, "z"))
    
    range.each do |i|
      assert_valid(password.ljust(i, "z"))
    end
  end
  
end