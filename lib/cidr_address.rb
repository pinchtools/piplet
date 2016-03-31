class CIDRAddress < NetAddr::CIDR

 
  def self.create(addr, options = nil)
    @addr = addr
  
    self.clean_up
    
    self.handle_wildcards if self.has_widcards?
    
    self.complete_ipv4_address if self.is_partial_ipv4_address?
    
    begin
      super(@addr, options)
    rescue
      nil
    end
  end

  
  def self.clean_up
    @addr.strip!
    @addr.gsub!(/\.+\z/, '') #remove ending dots
  end
  
  
  def  self.has_widcards?
    return !!(@addr =~ /\*/)
  end


  def self.is_partial_ipv4_address?
    return !!(@addr =~ /\A[\d\.]+\z/) && @addr.scan(/\./).size < 3
  end
  
  
  def self.complete_ipv4_address
    nb_missing_parts = 3 - @addr.scan(/\./).size
    
    nb_missing_parts.times { @addr += ".0" }
    
    @addr += "/#{32 - (nb_missing_parts * 8)}"
  end
  
  
  def self.handle_wildcards
    # strip ranges like "/16" from the end if present
    v = @addr.gsub(/\/.*/, '')

    return if v[v.index('*')..-1] =~ /[^\.\*]/

    parts = v.split('.')
    (4 - parts.size).times { parts << '*' } # support strings like 192.*
    v = parts.join('.')

    @addr = "#{v.gsub('*', '0')}/#{32 - (v.count('*') * 8)}"
  end

end