class LogDecorator < Draper::Decorator
  include Draper::LazyHelpers
  
  delegate_all
  
  # support for will_paginate
  delegate :current_page, :total_entries, :total_pages, :per_page, :offset
  
  def message
    (!!(object.message =~ /\Alogs\.messages\./)) ? I18n.t(object.message, object.message_vars) : object.message
  end

  def level
    if Log.important_actions.has_value?(object.action)
      "warning"
    elsif Log.sensitive_actions.has_value?(object.action)
      "danger"
    elsif Log.normal_actions.has_value?(object.action)
      "normal"
    end
  end
  
end
