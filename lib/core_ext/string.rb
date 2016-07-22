class String
  
  def capitalize_first
    self.slice(0,1).capitalize + self.slice(1..-1)
  end
  
end