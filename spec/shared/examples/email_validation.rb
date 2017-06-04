RSpec.shared_examples "email validation" do |attribute|
  let(:attribute) { attribute }
  let(:invalid_emails) { IO.read(Rails.root.join("spec", "fixtures", "lists", "emails_invalid.txt")).lines }
  let(:banned_domains) { IO.read(Rails.root.join("spec", "fixtures", "lists", "email_providers_banned.txt")).lines }
  let(:valid_intl_mails) { %w(用户@例子.广告 उपयोगकर्ता@उदाहरण.कॉम юзер@екзампл.ком θσερ@εχαμπλε.ψομ Dörte@Sörensen.example.com ) }

  def assert_invalid(email)
    subject[attribute] = email.strip
   
    expect(subject).not_to be_valid
    expect(subject.errors).to have_key(attribute.to_sym)
  end

 def assert_valid(email)
   subject[attribute] = email

   expect(subject).to be_valid
 end

  it 'disallows invalid emails' do
    invalid_emails.each do |email|
      assert_invalid(email.chomp)
    end
  end

  it 'disallows emails with banned domains' do
    banned_domains.each do |domain|
        assert_invalid("#{Faker::Internet.user_name}@#{domain}")
    end
  end

  it 'allows valid mails' do
    10.times do
      assert_valid(Faker::Internet.safe_email)
    end
  end

  it 'allows international emails' do
    valid_intl_mails.each do |email|
      assert_valid(email)
    end
  end

  it 'limits to 255 characters' do
    email = 'Faker::Internet.safe_email'

    255.times { email+= 'a' }

    assert_invalid(email.chomp)
  end
end