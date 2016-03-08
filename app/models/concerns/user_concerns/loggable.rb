module UserConcerns::Loggable
  extend ActiveSupport::Concern
  
  included do
    has_many :logs, class_name: 'UserLog', 
      foreign_key: 'concerned_user_id', 
      dependent: :destroy
  end
  
  def log( level, action, message, options  = {} )
    attributes = {
       :concerned_user_id => self.id,
       :level => level,
       :action => action,
       :message => message
     }
    
    attributes[:data] = options[:data]  if options[:data].present?
    attributes[:ip_address] = options[:data]  if options[:data].present?
     
     UserLog.delay.create(attributes) # async log
  end
  
  def log_notice(action, message, options  = {})
    log(UserLog.levels[:notice], action, message, options)
  end
  
  def log_important(action, message, options  = {})
    log(UserLog.levels[:important], action, message, options)
  end
  
  def log_restricted(action, message, options  = {})
    log(UserLog.levels[:restricted], action, message, options)
  end
end