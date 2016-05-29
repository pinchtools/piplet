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
require 'default_avatar'

class UserAvatar < ActiveRecord::Base
  belongs_to :user
  
  before_save :generate_default_image, if: :need_new_default_image?
  
  mount_uploader :uri, AvatarUploader
  
  validates :uri, 
    :file_size => { 
      :maximum => 2.megabytes.to_i
    }
    
  validates_integrity_of :uri, if: :upload?
  validates_processing_of :uri, if: :upload?
  
  enum kind: [ :default, :upload, :gravatar ]
    
  def gravatar?
    self.kind.to_s.to_sym == :gravatar
  end
  
  def upload?
    self.kind.to_s.to_sym == :upload
  end
  
  def default?
    self.kind.nil? || self.kind.to_sym == :default
  end
  
  private
  
  def need_new_default_image?
    self.default? && (new_record? || :kind_changed?)
  end
  
  def generate_default_image
    
    DefaultAvatar.generate_thumbnails( self.user.username )
    
  end
  
end
