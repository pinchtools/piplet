class LogDecorator < Draper::Decorator
  include Draper::LazyHelpers
  
  delegate_all
  
  # support for will_paginate
  delegate :current_page, :total_entries, :total_pages, :per_page, :offset
  
  def message
    (!!(object.message =~ /\Alogs\.messages\./)) ? I18n.t(object.message, object.message_vars) : object.message
  end

  def level
    levels = [ "normal", "warning", "danger" ]
    
    levels[ object.level - 1 ]
  end
  
  def data
    "<samp>" + JSON.pretty_generate(object.data).gsub("\n","<br/>") + "</samp>" if object.data.present?
  end
  
  def action_user
    user = User.select(:username).find_by_id(object.action_user_id)
    
    user.username if user.present?
  end
  
end
