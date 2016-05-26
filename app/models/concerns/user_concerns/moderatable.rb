module UserConcerns::Moderatable
  extend ActiveSupport::Concern
  
  included do
    scope :suspects, -> { where(suspected: true) }
    scope :all_blocked, -> { where(blocked: true) }
  end

  def blocked?
    #user can be blocked directly or impacted by a filter
    super || self.filters.all_blocked.any?
  end
  
  def trusted?
    self.filters.all_trusted.any?
  end
  
  def suspect_user(user, options = {})
    return false unless staff_member?
    
    log(:suspect_user, 
      link: Rails.application.routes.url_helpers.users_show_path( user.username_lower ))
    
    options[:suspected_by_id] = id

    user.suspect(options)
  end
  
  
  def suspect(options = {})
    # TODO some user shouldn't be suspected base on
    # trust level like leaders or regular
    return false if staff_member?
    columns = {
      suspected: true,
      suspected_at: DateTime.now
    }
    
    columns[:suspected_note] = options[:note] if options[:note].present?
    columns[:suspected_by_id] = options[:suspected_by_id] if options[:suspected_by_id].present?

    
    update_columns(columns)
  end
  
  
  def clear_suspect(user)
    return false unless staff_member?
    
    #add a log here to know whom cleared the user
    
    user.clear_as_suspect
  end
  
  
  def clear_as_suspect
    return false if staff_member?
    
    update_columns(
     suspected: false,
     suspected_at: nil,
     suspected_note: nil,
     suspected_by_id: nil
    )
  end
  
  
  def block_user(user)
    return false unless staff_member?
    
    log(:block_user, 
      link: Rails.application.routes.url_helpers.users_show_path( user.username_lower ))
    
    user.block({ blocked_by_id: id })
  end
  
  
  def block(options = {})
    return false if staff_member?
    
    log_options = {}
    
    log_options[:action_user_id] =  options[:blocked_by_id] if options[:blocked_by_id].present?
      
    log(:blocked, log_options)
    
    columns = {
      blocked: true,
      blocked_at: DateTime.now
    }
    
    columns[:blocked_by_id] = options[:blocked_by_id] if options[:blocked_by_id].present?
    
    update_columns(columns)
  end
  
  def unblock_user(user)
    return false unless staff_member?
    #add a log here to know whom cleared the user
     
    user.unblock
  end
  
  
  def unblock
    return false if staff_member?
    
    update_columns(
     blocked: false,
     blocked_at: nil,
     blocked_by_id: nil
    )
  end

end
