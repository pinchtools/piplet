require_dependency "banned_email_providers"

class EmailValidator < ActiveModel::EachValidator

  MAX_SIZE =  255.freeze

  attr_accessor :record, :attribute, :value

  def validate_each(record, attribute, value)
    return if value.blank?

    self.record = record
    self.attribute = attribute
    self.value = value

    is_using_banned_provider?
    well_formated?
    not_too_long?
  end

  def well_formated?
    record.errors.add(attribute, :invalid) unless value.include?('@')
  end

  def not_too_long?
    record.errors.add(attribute, :too_long, count: MAX_SIZE) if value.length > MAX_SIZE
  end

  def is_using_banned_provider?
    return unless record.errors.empty?

    if BannedEmailProviders.include?(value)
      record.errors.add(attribute, I18n.t(:'user.errors.email.provider-banned'))
    end
  end

end
