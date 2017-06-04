module MailerHelper
  def host
    #TODO use the domain of the default site
    ('localhost:' + ENV.fetch('PORT', '3000'))
  end
end