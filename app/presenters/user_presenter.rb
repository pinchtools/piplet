require 'letter_avatar/avatar_helper'

class UserPresenter < BasePresenter
  include LetterAvatar::AvatarHelper


  def avatar_thumbnail_path (options = { size: 80 })

    if avatar.present? && avatar.gravatar? then gravatar_thumbnail_path(options)
    elsif avatar.present? && avatar.upload? then upload_thumbnail_path(options)
    elsif !new_record? then default_thumbnail_path(options)
    end

  end


  def avatar_thumbnail_tag(options = { size: 80 })
    path = avatar_thumbnail_path(options)

    return h.image_tag(path, alt: username, width: options[:size], height: options[:size])
  end


  private


  def gravatar_thumbnail_path (options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(email.downcase)
    size = options[:size]

    url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mm"

    return h.raw url
  end


  def upload_thumbnail_path (options = { size: 80 })
    path = avatar.uri.large.url
    size = options[:size]

    if size <= AvatarUploader.small_size
      path = avatar.uri.small.url
    elsif size <= AvatarUploader.medium_size
      path = avatar.uri.medium.url
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

    return letter_avatar_url(username, thumbnail_size)
  end


end
