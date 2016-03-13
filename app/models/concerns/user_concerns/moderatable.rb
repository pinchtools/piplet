module UserConcerns::Moderatable
  extend ActiveSupport::Concern
  
  included do
    scope :suspects, -> { where(supected: true) }
    scope :all_blocked, -> { where(blocked: true) }
  end

  
  def suspect_user(user, options = {})
    return false unless staff_member?
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
    
    user.block({ blocked_by_id: id })
  end
  
  
  def block(options = {})
    return false if staff_member?
    
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
