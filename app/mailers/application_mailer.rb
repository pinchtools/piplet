class ApplicationMailer < ActionMailer::Base
  add_template_helper MailerHelper

  default from: "from@example.com"
  layout 'mailer'
end
