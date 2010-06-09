module Eschaton
  
  # Helps define attributes with different visibility in one place
  module ReadableAttributes # :nodoc:
  
    #  attributes :name => :reader
    #  attributes :project => :accessor
    #  attributes :center => [:reader, :protected => :writer}
    #  attributes :offset => [:writer, :protected => :reader}
    def attributes(options = {})
      options.each do |attribute, access|
        normalized_access = [access].flatten

        normalized_access.each do |access|
          visibility, access = if access.is_a?(Hash) # Means there is a visility to honour i.e {:protected => :writer}
                                access.to_a.flatten
                              else
                                [:public, access]
                              end

          eval "#{visibility}
               #{"attr_#{access}"} :#{attribute}"
        end
      end
    end
    
    def self.public_reader_protected_writer
      [:reader, {:protected => :writer}]
    end
  
  end

end