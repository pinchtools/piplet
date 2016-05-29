# encoding: utf-8

class AvatarUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  cattr_accessor :large_size, :medium_size, :small_size
  
  @@large_size= 240
  @@medium_size = 120
  @@small_size = 25
  
  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.user.username.parameterize}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  
  def content_type_whitelist
    /image\//
  end

   def filename
     "#{secure_token}.#{file.extension}" if original_filename.present?
   end
    
  version :large, :if => :valid_extension? do
      process :resize_and_crop => @@large_size
  end
  
   
  version :medium, :from_version => :large, :if => :valid_extension? do
    process :resize_and_crop => @@medium_size
  end
  
  
  version :small, :from_version => :medium, :if => :valid_extension? do
    process :resize_and_crop => @@small_size
  end
  
  private
  
     def valid_extension?(new_file)
       !!(new_file.content_type =~ /png|jpe?g|gif/)
     end
  
   def secure_token
     var = :"@#{mounted_as}_secure_token"
     model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
   end

   # Resize and crop square from Center
   def resize_and_crop(size)
     manipulate! do |image|
       if image[:width] < image[:height]
         remove = ((image[:height] - image[:width])/2).round 
         image.shave("0x#{remove}") 
       elsif image[:width] > image[:height] 
         remove = ((image[:width] - image[:height])/2).round
         image.shave("#{remove}x0")
       end
       image.resize("#{size}x#{size}")
       image
     end
   end

end