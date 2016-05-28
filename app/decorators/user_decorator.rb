class UserDecorator < Draper::Decorator
  include Draper::LazyHelpers
  
  delegate_all
  

  def avatar_thumbnail (options = { size: 80 })
    
    if model.avatar.is_gravatar? then gravatar_thumbnail(options)
    elsif model.avatar.is_upload? then upload_thumbnail(options)
    else default_thumbnail(options)
    end
  end
  
  
  private
  
  
  def gravatar_thumbnail (options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(model.email.downcase)
    size = options[:size]
      
    url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=mm"
    
    image_tag(raw(url), alt: model.username)
  end
  
  
  def upload_thumbnail (options = { size: 80 })
    path = model.avatar.uri.large.url
    size = options[:size]
    
    if size <= AvatarUploader.small_size
      path = model.avatar.uri.small.url
    elsif size <= AvatarUploader.medium_size
      path = model.avatar.uri.medium.url
    end
    
    image_tag(path, alt: model.username)
  end
  
  
  def default_thumbnail (options = { size: 80 })
    image_tag("/ze", alt: model.username)
  end


end
