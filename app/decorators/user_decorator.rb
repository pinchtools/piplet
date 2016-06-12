require 'letter_avatar/avatar_helper'

class UserDecorator < Draper::Decorator
  include Draper::LazyHelpers
  include LetterAvatar::AvatarHelper
  
  delegate_all
  
  # support for will_paginate
  delegate :current_page, :total_entries, :total_pages, :per_page, :offset
  

  def avatar_thumbnail_path (options = { size: 80 })

    if model.avatar.present? && model.avatar.gravatar? then gravatar_thumbnail_path(options)
    elsif model.avatar.present? && model.avatar.upload? then upload_thumbnail_path(options)
    elsif !model.new_record? then default_thumbnail_path(options)
    end
    
  end
  
  
  def avatar_thumbnail_tag(options = { size: 80 })
    path = avatar_thumbnail_path(options)
    
    return image_tag(path, alt: model.username, width: options[:size], height: options[:size])
  end
  
  
  private
  
  
  def gravatar_thumbnail_path (options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(model.email.downcase)
    size = options[:size]
      
    url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mm"
    
    return raw(url)
  end
  
  
  def upload_thumbnail_path (options = { size: 80 })
    path = model.avatar.uri.large.url
    size = options[:size]
    
    if size <= AvatarUploader.small_size
      path = model.avatar.uri.small.url
    elsif size <= AvatarUploader.medium_size
      path = model.avatar.uri.medium.url
    end
    
    return path
  end
  
  
  def default_thumbnail_path (options = { size: 80 })
    size = options[:size]
    
    thumbnail_size = DefaultAvatar.large_size
    
    if size <= DefaultAvatar.small_size
      thumbnail_size = DefaultAvatar.small_size
    elsif size <= DefaultAvatar.medium_size
      thumbnail_size = DefaultAvatar.medium_size
    end
    
    return letter_avatar_url(model.username, thumbnail_size)
  end


end
