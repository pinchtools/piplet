RSpec.shared_context "url validation" do |attribute|
  invalid_urls = IO.read(Rails.root.join("spec", "fixtures", "lists", "urls_invalid.txt")).lines

  let(:attribute) { attribute }

 def assert_invalid(url)
  
   subject[attribute] = url.strip
   
  subject.valid?

   expect(subject.errors).to have_key(attribute.to_sym)
 end

 def assert_valid(url)
   subject[attribute] = url

   expect(subject).to be_valid
 end

 invalid_urls.each do |url|
   url = url.chomp

   it "disallows #{url}" do
     assert_invalid(url)
   end
 end

 10.times do
   url = Faker::Internet.url
   it "allows #{url}" do
     assert_valid(url)
   end
 end
 
end