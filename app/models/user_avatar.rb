# == Schema Information
#
# Table name: user_avatars
#
#  id         :integer          not null, primary key
#  kind       :integer
#  uri        :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'file_size_validator' 

class UserAvatar < ActiveRecord::Base
  belongs_to :user
  
  mount_uploader :uri, AvatarUploader
  
  validates :uri, 
    :file_size => { 
      :maximum => 2.megabytes.to_i 
    }
  
  enum kind: [ :default, :upload, :gravatar ]
    
    
  def is_gravatar?
    self.kind.to_sym == :gravatar
  end
  
  def is_upload?
    self.kind.to_sym == :upload
  end
  
end
