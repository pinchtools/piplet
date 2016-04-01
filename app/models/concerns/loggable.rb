module Concerns::Loggable
  extend ActiveSupport::Concern
  
  included do
    has_many :logs, as: :loggable, dependent: :destroy
  end
  
  def log( action, options  = {} )
    return if Log.actions[action].nil?
    
    attributes = {
       :action => Log.actions[action]
    }
    
    attributes[:message] = options[:message] || "log.messages.#{action}"

    attributes[:message_vars] = options[:message_vars] if options[:message_vars].present? 
    attributes[:data] = options[:data] if options[:data].present?
    attributes[:link] = options[:link] if options[:link].present?
    attributes[:ip_address] = options[:ip_address] if options[:ip_address].present?
    attributes[:action_user_id] = options[:action_user_id] if options[:action_user_id].present?
      
#     log = Log.new(attributes)
#     
#     log.loggable = self
#     
#     log.delay.save
    self.logs.delay.create(attributes) # async log
  end

end