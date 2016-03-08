# == Schema Information
#
# Table name: user_histories
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
#  index_user_histories_on_action          (action)
#  index_user_histories_on_action_user_id  (action_user_id)
#  index_user_histories_on_level           (level)
#

require "enum"

class UserHistory < ActiveRecord::Base
  
  validates :action, presence: true, inclusion: {  :in => proc { self.actions } }
  validates :level, presence: true,  inclusion: {  :in => proc { self.levels } }
  validates :message, presence: true
  validates :concerned_user_id, presence: true
    
   
  
  def self.actions
    @actions ||= Enum.new(create_user: 1,
                          registrate_user: 2,
                          suspect_user: 3
     )
  end
  
  def self.levels
    @levels ||= Enum.new(
        notice: 1,
        important: 2,
        restricted: 3
      )
  end
end
