LetterAvatar.generate 'ksz2k', 200
class DefaultAvatar
  
  include LetterAvatar::AvatarHelper
  
  cattr_accessor :large_size, :medium_size, :small_size
    
  @@large_size= 240
  @@medium_size = 120
  @@small_size = 25
  
  def self.sizes
    {
      :large_size => @@large_size,
      :medium_size => @@medium_size,
      :small_size => @@small_size
    }
  end
  
  def self.generate_thumbnails( key )
    self.sizes.values.each do |size|
      LetterAvatar.generate key, size
    end
  end
  
end