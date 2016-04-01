# == Schema Information
#
# Table name: logs
#
#  id             :integer          not null, primary key
#  action         :integer
#  level          :integer
#  message        :text
#  data           :text
#  ip_address     :inet
#  link           :string
#  message_vars   :string
#  action_user_id :integer
#  loggable_id    :integer
#  loggable_type  :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_logs_on_action                         (action)
#  index_logs_on_action_user_id                 (action_user_id)
#  index_logs_on_level                          (level)
#  index_logs_on_loggable_type_and_loggable_id  (loggable_type,loggable_id)
#

require 'enum'

class Log < ActiveRecord::Base

  before_validation :set_level
  
  validates :action, presence: true, inclusion: { :in => proc { self.actions.values } }
  validates :level, presence: true, inclusion: { :in => proc { self.levels.values } }
  validates :message, presence: true
  validates :loggable, presence: true
  
  validate :action_user_on_sensitive_log
  
  belongs_to :loggable, polymorphic: true
  belongs_to :action_user, :class_name => 'User'
  
  
  def self.normal_actions
    @info_actions ||= Enum.new(
      generic: 1
    )
  end
  
  
  def self.important_actions
    @important_actions ||= Enum.new(
      created: 1000
    )
  end

  
  def self.sensitive_actions
    @sensitive_actions ||= Enum.new(
      suspected: 2000,
      admin: 2001,
      set_user_admin: 2002,
      request_password_reset: 2003,
      password_reset: 2004,
      activated: 2005,
      login: 2006,
      block_user: 2007,
      blocked: 2008,
      suspect_user: 2009
    )
  end
  
  
  def self.actions
    @actions ||= self.normal_actions
      .merge(self.important_actions)
      .merge(self.sensitive_actions)
  end
  
  
  def self.levels
    @levels ||= Enum.new(
        normal: 1,
        important: 2,
        sensitive: 3
      )
  end
  
  
  private
  
  
  def set_level
    return if action.nil?

    self.level = guess_level
  end
  
  
  def guess_level
    return Log.levels[:normal] if has_normal_action?
    return Log.levels[:important] if has_important_action?
    return Log.levels[:sensitive] if has_sensitive_action?
    nil
  end

  
  def has_normal_action?
    Log.normal_actions.has_value? action
  end

  
  def has_important_action?
    Log.important_actions.has_value? action
  end
  
  
  def has_sensitive_action?
    Log.sensitive_actions.has_value? action
  end
  
  def action_user_on_sensitive_log
    return if action_user.nil?

    if level == Log.levels[:sensitive] && action_user.regular?
      self.errors.add(:action_user, I18n.t(:'log.errors.action-user.must-be-staff-member'))
    end

  end

  
end
