module UserConcerns::Loggable
  extend ActiveSupport::Concern
  
  included do
    has_many :logs, class_name: 'UserLog', 
      foreign_key: 'concerned_user_id', 
      dependent: :destroy
  end
  
  def log( action, options  = {} )
    attributes = {
       :concerned_user_id => self.id,
       :action => UserLog.actions[action],
       
    }
    
    attributes[:message] = options[:message] || "user-log.messages.#{action}"

    attributes[:data] = options[:data]  if options[:data].present?
    attributes[:link] = options[:link]  if options[:link].present?
    attributes[:ip_address] = options[:ip_address]  if options[:ip_address].present?
   
    UserLog.delay.create(attributes) # async log
  end

end