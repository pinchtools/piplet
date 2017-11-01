class Users::ConcernedByFiltersService
  ##return true false and add error to @user if detected
  #does .save failed if an error as been added ?
  def initialize(user)
    @user = user
  end

  def call
    is_concerned = concerned_by_email_filter ||
      (@user.creation_ip_address && concerned_by_ip_filter)

    @user.errors.add(:base, I18n.t('user.notice.danger.unexpected-error')) if is_concerned

    return is_concerned
  end

  private

  def concerned_by_email_filter
    UserFilter.all_blocked.exists?(email_provider: email_provider)
  end

  def concerned_by_ip_filter
    UserFilter.all_blocked.where("cidr_address >>= ?", @user.creation_ip_address.to_cidr_s).exists?
  end

  def email_provider
    (@user.email) ? @user.email.partition('@').last : nil
  end
end
