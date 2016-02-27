RSpec.shared_context "username validation" do |attribute|
  #invalid_emails = IO.read(Rails.root.join("spec", "fixtures", "lists", "emails_invalid.txt")).lines

  let(:attribute) { attribute }

  def assert_invalid(username)
    subject[attribute] = username
     
    subject.valid?
  
    expect(subject.errors).to have_key(attribute.to_sym)
  end
  
  
  # username whith invalid characters
  invalid_chars = %w{
    foo;bar
    foo;b*ar
    .foobar
    -foobar
    foobar.
    foobar-
    f__bar
    f--bar
    f..bar
    foobar.js
    foobar.jpeg
  }
  
  invalid_chars.each do | username |
    it 'should not accept username with invalid characters' do 
      assert_invalid(username)
    end
  end
  
#    
#  def char_valid?
#    return unless errors.empty?
#    if username =~ /[^A-Za-z0-9_\.\-]/
#      record.errors.add(attribute, I18n.t(:'user.errors.username.characters'))
#    end
#  end
#
#  def first_char_valid?
#    return unless errors.empty?
#    if username[0] =~ /[^A-Za-z0-9_]/
#    record.errors.add(attribute, I18n.t(:'user.errors.username.must_begin_with_alphanumeric'))
#    end
#  end
#
#  def last_char_valid?
#    return unless errors.empty?
#    if username[-1] =~ /[^A-Za-z0-9_]/
#      record.errors.add(attribute, I18n.t(:'user.errors.username.must_end_with_alphanumeric'))
#    end
#  end
#
#  def no_double_special?
#    return unless errors.empty?
#    if username =~ /[\-_\.]{2,}/
#      record.errors.add(attribute, I18n.t(:'user.errors.username.must_not_contain_two_special_chars_in_seq'))
#    end
#  end
#
#  def does_not_end_with_confusing_suffix?
#    return unless errors.empty?
#    if username =~ /\.(json|gif|jpeg|png|htm|js|json|xml|woff|tif|html)/i
#      record.errors.add(attribute, I18n.t(:'user.errors.username.must_not_contain_confusing_suffix'))
#    end
#  end
#
#    
# def assert_invalid(email)
#  
#   subject[attribute] = email
#   
#  subject.valid?
#
#   expect(subject.errors).to have_key(attribute.to_sym)
# end
#
# def assert_valid(email)
#   subject[attribute] = email
#
#   expect(subject).to be_valid
# end
#
# invalid_emails.each do |email|
#   email = email.chomp
#
#   it "disallows #{email}" do
#     assert_invalid(email)
#   end
# end
#
# 10.times do
#   email = Faker::Internet.email
#   it "allows #{email}" do
#     assert_valid(email)
#   end
# end
# 
end