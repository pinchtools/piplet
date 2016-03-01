RSpec.shared_context "email validation" do |attribute|
  invalid_emails    = IO.read(Rails.root.join("spec", "fixtures", "lists", "emails_invalid.txt")).lines
  banned_domains = IO.read(Rails.root.join("spec", "fixtures", "lists", "email_providers_banned.txt")).lines

  let(:attribute) { attribute }

  def assert_invalid(email)
  
    subject[attribute] = email.strip
   
    subject.valid?

    expect(subject.errors).to have_key(attribute.to_sym)
  end

 def assert_valid(email)
   subject[attribute] = email

   expect(subject).to be_valid
 end

  invalid_emails.each do |email|
    email = email.chomp

   it "disallows #{email}" do
     assert_invalid(email)
   end
  end
 
  banned_domains.each do |domain|
    3.times.each do
      email =  "#{Faker::Internet.user_name}@#{domain}"
    
      it "disallows #{email}" do
        assert_invalid(email)
      end
    end
  end
 
 10.times do
   email = Faker::Internet.email
   it "allows #{email}" do
     assert_valid(email)
   end
 end
 
 valid_intl_mails = %w(
 用户@例子.广告
 उपयोगकर्ता@उदाहरण.कॉम
 юзер@екзампл.ком
 θσερ@εχαμπλε.ψομ
 Dörte@Sörensen.example.com )

 valid_intl_mails.each do |email|
    it "allows #{email}" do
      assert_valid(email)
    end
  end
  
end