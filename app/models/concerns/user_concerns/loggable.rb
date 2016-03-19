module UserConcerns::Loggable
  extend ActiveSupport::Concern
  
  included do
    has_many :logs, class_name: 'UserLog', 
      foreign_key: 'concerned_user_id', 
      dependent: :destroy
  end
  
  def log( action, options  = {} )
    return if UserLog.actions[action].nil?
    
    attributes = {
       :concerned_user_id => self.id,
       :action => UserLog.actions[action],
       
    }
    
    attributes[:message] = options[:message] || "user-log.messages.#{action}"

    attributes[:message_vars] = options[:message_vars] if options[:message_vars].present? 
    attributes[:data] = options[:data] if options[:data].present?
    attributes[:link] = options[:link] if options[:link].present?
    attributes[:ip_address] = options[:ip_address] if options[:ip_address].present?
    attributes[:action_user_id] = options[:action_user_id] if options[:action_user_id].present?
      
    UserLog.delay.create(attributes) # async log
  end

end