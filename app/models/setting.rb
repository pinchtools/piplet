# RailsSettings Model
class Setting < RailsSettings::CachedSettings
  @@DEFAULT_SETTING_ROOT = Rails.root.join('config', 'settings')
  
  
  def self.load_default_settings
    Dir["#{@@DEFAULT_SETTING_ROOT}/*.yml"].each do |file| 
      basename = File.basename(file, ".yml")
      conf = load_yml_from_file(file)
      
      create_section_settings(basename, conf)
    end
  end
  
  
  def self.create_section_settings(section_name, hash )
    hash.each do |key, value|
      self.defaults["#{section_name}.#{key}"] = value
    end
  end
  
  private
  
  
  def self.load_yml_from_file(file)
    YAML::load( File.open(file) )
  end
end
