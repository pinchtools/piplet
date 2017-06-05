module MailerHelper
  def host
    ('localhost:' + ENV.fetch('PORT', '3000'))
  end
end