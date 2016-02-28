RSpec.shared_context "email validation" do |attribute|
  invalid_emails = IO.read(Rails.root.join("spec", "fixtures", "lists", "emails_invalid.txt")).lines

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

 10.times do
   email = Faker::Internet.email
   it "allows #{email}" do
     assert_valid(email)
   end
 end
 
end