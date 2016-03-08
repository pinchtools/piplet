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
  
  validates :action, presence: true, inclusion: { :in => proc { self.actions.values } }
  validates :level, presence: true,  inclusion: { :in => proc { self.levels.values } }
  validates :message, presence: true
  validates :concerned_user_id, presence: true
    
   belongs_to :concerned_user, :class_name => 'User'
   has_one :action_user, :class_name => 'User'
  
  def self.actions
    @actions ||= Enum.new(
      created: 1,
      registrated: 2,
      suspected: 3,
      admin: 4,
      set_user_admin: 5)
  end
  
  
  def self.levels
    @levels ||= Enum.new(
        notice: 1,
        important: 2,
        restricted: 3
      )
  end
  
  
  
end
