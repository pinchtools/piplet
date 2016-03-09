# == Schema Information
#
# Table name: user_logs
#
#  id                :integer          not null, primary key
#  action            :integer
#  level             :integer
#  message           :text
#  data              :text
#  ip_address        :string
#  action_user_id    :integer
#  concerned_user_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_user_logs_on_action          (action)
#  index_user_logs_on_action_user_id  (action_user_id)
#  index_user_logs_on_level           (level)
#

require "enum"

class UserLog < ActiveRecord::Base
  
  before_validation :set_level
  
  validates :action, presence: true, inclusion: { :in => proc { self.actions.values } }
  validates :level, presence: true,  inclusion: { :in => proc { self.levels.values } }
  validates :message, presence: true
  validates :concerned_user_id, presence: true
  
  belongs_to :concerned_user, :class_name => 'User'
  has_one :action_user, :class_name => 'User'
  
  
  def self.normal_actions
    @info_actions ||= Enum.new(
      generic: 1
    )
  end
  
  
  def self.important_actions
    @important_actions ||= Enum.new(
      created: 1000,
      registrated: 1002
    )
  end

  
  def self.sensitive_actions
    @sensitive_actions ||= Enum.new(
      suspected: 2000,
      admin: 2001,
      set_user_admin: 2002
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
    return UserLog.levels[:normal] if has_normal_action?
    return UserLog.levels[:important] if has_important_action?
    return UserLog.levels[:sensitive] if has_sensitive_action?
    nil
  end

  
  def has_normal_action?
    UserLog.normal_actions.has_value? action
  end

  
  def has_important_action?
    UserLog.important_actions.has_value? action
  end
  
  
  def has_sensitive_action?
    UserLog.sensitive_actions.has_value? action
  end
  
end