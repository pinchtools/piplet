module Concerns::Loggable
  extend ActiveSupport::Concern
  
  included do
    has_many :logs, as: :loggable, dependent: :destroy
  end
  
  def log( action, options  = {} )
    return if Log.actions[action].nil?

    # TODO: interest of these 3 lines ?
    empty_log = self.logs.new
    attributes = empty_log.attributes

     self.logs.delete(empty_log)
    
    attributes[:action] = Log.actions[action]
    attributes[:message] = options[:message] || "logs.messages.#{action}"

    attributes[:message_vars] = options[:message_vars] if options[:message_vars].present? 
    attributes[:data] = options[:data] if options[:data].present?
    attributes[:link] = options[:link] if options[:link].present?
    attributes[:ip_address] = options[:ip_address] if options[:ip_address].present?
    attributes[:action_user_id] = options[:action_user_id] if options[:action_user_id].present?

    Log.delay.create(attributes) # async log
  end

end