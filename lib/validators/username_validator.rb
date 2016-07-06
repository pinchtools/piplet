require_dependency "reserved_usernames"

class UsernameValidator < ActiveModel::EachValidator

  attr_accessor :record, :attribute, :value
  
  def validate_each(record, attribute, value)
    return if value.blank?
    
    self.record = record
    self.attribute = attribute
    self.value = value

    char_valid?
    first_char_valid?
    last_char_valid?
    no_double_special?
    does_not_end_with_confusing_suffix?
    reserved?
    renewed_max?
    
  end
  

  private

  def char_valid?
    return unless record.errors.empty?
    if self.value =~ /[^A-Za-z0-9_\.\-]/
      record.errors.add(self.attribute, I18n.t(:'user.errors.username.characters'))
    end
  end

  def first_char_valid?
    return unless record.errors.empty?
    if self.value[0] =~ /[^A-Za-z0-9_]/
    record.errors.add(self.attribute, I18n.t(:'user.errors.username.must-begin-with-alphanumeric'))
    end
  end

  def last_char_valid?
    return unless record.errors.empty?
    if self.value[-1] =~ /[^A-Za-z0-9_]/
      record.errors.add(self.attribute, I18n.t(:'user.errors.username.must-end-with-alphanumeric'))
    end
  end

  def no_double_special?
    return unless record.errors.empty?
    if self.value =~ /[\-_\.]{2,}/
      record.errors.add(self.attribute, I18n.t(:'user.errors.username.must-not-contain-two-special-chars-in-seq'))
    end
  end

  def does_not_end_with_confusing_suffix?
    return unless record.errors.empty?
    if self.value =~ /\.(json|gif|jpeg|png|htm|js|json|xml|woff|tif|html)/i
      record.errors.add(self.attribute, I18n.t(:'user.errors.username.must-not-contain-confusing-suffix'))
    end
  end

  def reserved?
    return unless record.errors.empty?
    if ReservedUsernames.include?(self.value)
      record.errors.add(self.attribute, I18n.t(:'user.errors.username.reserved'))
    end
  end

  def renewed_max?
    if record.username_renew_count + 1 > Setting['user.max_username_renew']
      record.errors.add(attribute, I18n.t('user.errors.username.max-renewal', :max => Setting['user.max_username_renew'] ))
    end
  end
  
end