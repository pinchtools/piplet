module UserConcerns::Moderatable
  extend ActiveSupport::Concern

  included do
    scope :suspects, -> { where(suspected: true).order( suspected_at: :desc ) }
    scope :all_blocked, -> { where(blocked: true).order( blocked_at: :desc ) }
  end

  def blocked?
    #user can be blocked directly or impacted by a filter
    super || Users::ConcernedByFiltersService.new(self).call
  end

  def trusted?
    self.filters.all_trusted.any?
  end

  def suspect_user(user, options = {})
    return false unless admin?

    log(:suspect_user,
      link: Rails.application.routes.url_helpers.admin_users_dashboard_index_path( user.username_lower ))

    options[:suspected_by_id] = id

    user.suspect(options)
  end


  def suspect(options = {})
    # TODO some user shouldn't be suspected base on
    # trust level like leaders or regular
    return false if admin?

    #unblock user if needed
    unblock if blocked?

    columns = {
      suspected: true,
      suspected_at: DateTime.now
    }

    log_options = { data: {} }

    log_options[:data][:note] = options[:suspected_note] if options[:suspected_note].present?

    log(:suspected)

    columns[:suspected_note] = options[:suspected_note] if options[:suspected_note].present?
    columns[:suspected_by_id] = options[:suspected_by_id] if options[:suspected_by_id].present?

    begin
      return update_columns(columns)
    rescue
      return false
    end
  end

  #cancel a user suspection
  def trust_user(user)
    return false unless admin?

    log(:trust_user,
      link: Rails.application.routes.url_helpers.admin_users_dashboard_index_path( user.username_lower ))


    user.trust
  end

  #cancel suspection
  def trust
    return false if admin?

    log(:trusted)

    begin
      return update_columns(
       suspected: false,
       suspected_at: nil,
       suspected_note: nil,
       suspected_by_id: nil
      )
    rescue
      return false
    end
  end


  def block_user(user, options = {})
    return false unless admin?

    log(:block_user,
      link: Rails.application.routes.url_helpers.admin_users_dashboard_index_path( user.username_lower ))

    options[:blocked_by_id] = id

    user.block(options)
  end


  def block(options = {})
    return false if admin?

    log_options = { data: {} }

    log_options[:action_user_id] =  options[:blocked_by_id] if options[:blocked_by_id].present?

    log_options[:data][:note] = options[:blocked_note] if options[:blocked_note].present?

    log(:blocked, log_options)

    columns = {
      blocked: true,
      blocked_at: DateTime.now
    }

    columns[:blocked_by_id] = options[:blocked_by_id] if options[:blocked_by_id].present?
    columns[:blocked_note] = options[:blocked_note] if options[:blocked_note].present?

    begin
      update_columns(columns)
    rescue
      return false
    end
  end

  def unblock_user(user)
    return false unless admin?
    #add a log here to know whom cleared the user

    log(:unblock_user,
          link: Rails.application.routes.url_helpers.admin_users_dashboard_index_path( user.username_lower ))


    user.unblock
  end


  def unblock
    return false if admin?

    log(:unblocked)

    begin
      update_columns(
       blocked: false,
       blocked_at: nil,
       blocked_note: nil,
       blocked_by_id: nil
      )
    rescue
      return false
    end
  end

end
