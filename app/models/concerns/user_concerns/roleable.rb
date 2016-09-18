module UserConcerns::Roleable
  extend ActiveSupport::Concern
  
  included do
    scope :admins, -> { where(admin: true) }
    scope :staff, -> { where(admin: true).order( created_at: :asc ) }
  end

  def regular?
    !admin?
  end

  def grant_admin!
    set_permission('admin', true)
  end

  def revoke_admin!
    set_permission('admin', false)
  end

  def set_permission(permission_name, value)
    self.send("#{permission_name}=", value)
    self.save!
  end

end
