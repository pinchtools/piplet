class ReservedUsernames
  
  @@list = []
  
  def self.include?(username)
    self.load unless @@list.any?
    
    !!self.search(username)
  end
  
  def self.load
    data = File.read( Rails.root.join("config", "lists", "reserved_usernames.txt") )
    @@list = data.split( /\r?\n/ )
  end
  
  def self.get_list
    @@list
  end
  
  def self.search(username)
    @@list.find {|value| value == username }
  end

end