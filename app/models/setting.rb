# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  var        :string           not null
#  value      :text
#  thing_id   :integer
#  thing_type :string(30)
#  created_at :datetime
#  updated_at :datetime
#
# Indexes
#
#  index_settings_on_thing_type_and_thing_id_and_var  (thing_type,thing_id,var) UNIQUE
#

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
  
  
  def self.[](var_name)
    if var = object(var_name)
      val = var.value
    else
      val = self.defaults[var_name]
    end
    val
  end
  
  private
  
  
  def self.load_yml_from_file(file)
    YAML::load( File.open(file) )
  end
end
