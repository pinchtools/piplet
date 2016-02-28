class CommonPasswords
  
  @@list = []
  
  def self.include?(password)
    self.load unless @@list.any?
    
    !!self.search(password)
  end
  
  def self.load
    data = File.read( Rails.root.join("lib", "common_passwords", "list.txt") )
    @@list = data.split( /\r?\n/ )
  end
  
  def self.get_list
    @@list
  end
  
  def self.search(password)
    @@list.find {|pass| pass == password }
  end

end