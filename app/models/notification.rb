# == Schema Information
#
# Table name: notifications
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  kind        :integer
#  read        :boolean          default(FALSE)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  link        :string
#
# Indexes
#
#  index_notifications_on_kind     (kind)
#  index_notifications_on_user_id  (user_id)
#

class Notification < ActiveRecord::Base
  
  belongs_to :user
  
  validates :title, presence: true
  validates :kind, presence: true
  validates :user_id, presence: true
  
  enum kind: [
    :unknown,
    :acquired_badge,
    :acquired_privilege,
    :username_changed,
    :email_changed,
    :password_changed,
    :liked_report,
    :quoted_report,
    :replied,
    :task_started,
    :task_processed
    ]

  def self.send_to(user)
    notif = Notification.new
    
    yield(notif)
    
    notif.user = user
    
    return Notification.delay.create(notif.attributes.except('id'))
      
    
   # ex Notification.send_to(user) do
    # title: 'xxx'
  # end
    #NotificationWorker.perform_async(attributes)
#    notif = user.notifications.new
#    yield notif
#    
#    notif.save
  end
    
end
