class BannedEmailProviders
  
  @@list = []
  
  def self.include?(email)
    self.load unless @@list.any?
    
    !!self.search(email)
  end
  
  def self.load
    data = File.read( Rails.root.join("config", "lists", "banned_email_providers.txt") )
    @@list = data.split( /\r?\n/ )
  end
  
  def self.get_list
    @@list
  end
  
  def self.search(email)
    @@list.find {|m| !!(email =~ /#{m}\z/i) }
  end

end