require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "account_activation" do
    let(:user) { 
      user = create(:user)
      user.activation_token = User.new_token
      
      return user
    }
    let(:mail) { UserMailer.account_activation(user, user.activation_token) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.username)
      expect(mail.body.encoded).to match(user.activation_token)
      expect(mail.body.encoded).to match( CGI::escape(user.email) )
    end
  end

  describe "password_reset" do
    let(:user) { 
      user = create(:user)
      user.reset_token = User.new_token
      
      return user
    }
    
    let(:mail) { UserMailer.password_reset(user, user.reset_token) }

    it "renders the headers" do
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.reset_token)
      expect(mail.body.encoded).to match( CGI::escape(user.email) )
    end
  end

end
