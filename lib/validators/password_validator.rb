require_dependency "common_passwords"

class PasswordValidator < ActiveModel::EachValidator

  attr_accessor :record, :attribute, :value
  

  
  
  def validate_each(record, attribute, value)
    return if value.blank?
    
    self.record = record
    self.attribute = attribute
    self.value = value
    
    if record.username.present? && value == record.username
      record.errors.add(attribute, I18n.t(:'user.errors.password.same-as-username'))
    elsif record.email.present? && value == record.email
      record.errors.add(attribute, I18n.t(:'user.errors.password.same-as-email'))
    elsif CommonPasswords.include?(value)
      record.errors.add(attribute, I18n.t(:'user.errors.password.common'))
    end
    
    length_valid?
    
  end
  
  private
  
  def length_valid?
    range = record.class.min_password_characters..record.class.max_password_characters
    
    unless range.member? self.value.length
      record.errors.add self.attribute, I18n.t(:'user.errors.password.must-be-within-characters', min: range.first, max: range.last)
    end
  end
end