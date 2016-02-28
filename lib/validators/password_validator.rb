require_dependency "common_passwords"

class PasswordValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    return if value.blank?
    
    if record.username.present? && value == record.username
      record.errors.add(attribute, I18n.t(:'user.errors.password.same_as_username'))
    elsif record.email.present? && value == record.email
      record.errors.add(attribute, I18n.t(:'user.errors.password.same_as_email'))
    elsif CommonPasswords.include?(value)
      record.errors.add(attribute, I18n.t(:'user.errors.password.common'))
    end
    
  end
end