require_dependency "banned_email_providers"

class EmailValidator < ActiveModel::EachValidator

  attr_accessor :record, :attribute, :value
  
  def validate_each(record, attribute, value)
    return if value.blank?
    
    self.record = record
    self.attribute = attribute
    self.value = value
    
    is_using_banned_provider?
  end
  
  def is_using_banned_provider?
    return unless record.errors.empty?
    
    if BannedEmailProviders.include?(value)
      record.errors.add(attribute, I18n.t(:'user.errors.email.provider_banned'))
    end
  end
  
end