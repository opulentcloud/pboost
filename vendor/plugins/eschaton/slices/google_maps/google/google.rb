module Google
  @@current_map = nil

  def self.current_map=(map)
    @@current_map = map
  end

  def self.current_map
    @@current_map
  end   
      
end