module Eschaton

  # Encapsulates a javascript variable in a Ruby variable. This can be used to work with a javascript variable within Ruby.
  #
  # ==== Examples
  #  # Create a new variable
  #  my_array = JavascriptVariable.new(:name => :my_array, :value => "new Array()")
  #  my_array.push("One")
  #  my_array.push(2)
  #  my_array.push("Three")
  #
  #  my_array.splice(1, 0, "A new item at position 1")
  #
  #  # Reference an existing variable
  #  my_existing_array = JavascriptVariable.existing(:var => :my_array)
  #  my_existing_array.push("Four")
  #  my_existing_array.push(5)
  class JavascriptVariable < JavascriptObject

    def initialize(options = {})
      options.default! :value => nil, :var => options[:name]

      super

      if self.create_var?
        self << "var #{self.var} = #{options[:value]};"
      end
    end

    def [](key)
      "#{self.var}[#{key.to_js}]".to_sym
    end

    def []=(key, value)
      self << "#{self[key]} = #{value.to_js};"
    end
    
    # Iterates over the variable, passing each element as a parameter to the block and outputs the javascript needed 
    # to perform the loop on the client.
    #
    # ==== Examples
    #   the_array = Eschaton::JavascriptVariable.new(:var => :my_array, :value => '["one", "two", "three"]')
    #
    #   # Alert each element
    #   the_array.each do |element|
    #     script << "alert(#{element});"
    #   end
    def each
      self << "jQuery.each(#{self}, function(index, item){"
      yield JavascriptVariable.existing(:var => :item)
      self << "});"
    end
    
    # Iterates over the variable, passing each element and its index as parameters to the block and outputs the javascript needed 
    # to perform the loop on the client.
    #
    # ==== Examples
    #   # Using an Associative array
    #   the_array = Eschaton::JavascriptVariable.new(:var => :my_array, :value => '{"name": "yawningman", "project": "eschaton"}')
    #
    #   # Alert each element and its index
    #   the_array.each_with_index do |element, index|
    #     script << "alert(#{element} + ' is at ' + #{index});"
    #   end
    #
    #   # Using a normal array
    #   the_array = Eschaton::JavascriptVariable.new(:var => :my_array, :value => '[0, 1, 2]')
    #
    #   # Alert each element and its index
    #   the_array.each_with_index do |element, index|
    #     script << "alert(#{element} + ' is at ' + #{index});"
    #   end
    #
    def each_with_index
      self << "jQuery.each(#{self}, function(index, item){"
      yield JavascriptVariable.existing(:var => :item), JavascriptVariable.existing(:var => :index)
      self << "});"
    end    

  end

end