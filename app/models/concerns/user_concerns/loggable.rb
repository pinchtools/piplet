module UserConcerns::Loggable
  extend ActiveSupport::Concern
  
  included do
    has_many :logs, class_name: 'UserLog', 
      foreign_key: 'concerned_user_id', 
      dependent: :destroy
  end
  
  def log( action, message, options  = {} )
    attributes = {
       :concerned_user_id => self.id,
       :action => action,
       :message => message
     }
    
    attributes[:data] = options[:data]  if options[:data].present?
    attributes[:ip_address] = options[:data]  if options[:data].present?
     
     UserLog.delay.create(attributes) # async log
  end

end