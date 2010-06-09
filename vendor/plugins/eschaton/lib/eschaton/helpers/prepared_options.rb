module Eschaton
  
  # Helps with writing methods that take a +options+ hash.
  #
  # ==== Examples
  #  # A sample initializer in which the PreparedOptions is used.
  #  def initialize(options = {})
  #    prepared_options = options.prepare_options do |prepared_options|
  #                         prepared_options.default! :var => :map, :center => :best_fit, :zoom => :best_fit,
  #                                                   :keyboard_navigation => false
  #
  #                         prepared_options.validate_presence_of :center, :controls, :zoom, :type, 
  #                                                               :keyboard_navigation
  #                        end
  # 
  #    # ...work with prepared options here
  #  end  
  class PreparedOptions # :nodoc:

    def initialize(options = {})
      self.options = options.clone
      self.options.symbolize_keys!
    end
    
    # Used to access option values. 
    # 
    # If a single option is passed in the single value is returned.
    #  prepared_options[:name] #=> "yawningman"
    #  prepared_options[:project] #=> "eschaton"
    #
    # If multiple options are passed in, a hash of those options is returned.
    #  prepared_options[:name, :project] #=> {:name => "yawningman", :project => "eschaton"}
    def [](*options)
      if options.size == 1
        self.options[options.first]
      else
        hash = {}

        options.each do |option|
          hash[option] = self[option]
        end

        hash.symbolize_keys
      end
    end

    # Assigns an option a value.
    #
    #  prepared_options[:name] => "yawningman"
    #  prepared_options[:project] => "eschaton"
    def []=(option, value)
      self.options[option] = value
    end
    
    # Returns a value indicating if the +option+ is present.
    #
    #  prepared_options = PreparedOptions.new(:name => "yawningman")
    #
    #  prepared_options.has_option?(:name) #=> true
    #  prepared_options.has_option?(:project) #=> false
    def has_option?(option)
      self.options.has_key?(option)
    end

    # Returns a value indicating if the +option+ has a value.
    #
    #  prepared_options = PreparedOptions.new(:name => "yawningman", :project => nil)
    #
    #  prepared_options.has_value?(:name) #=> true
    #  prepared_options.has_value?(:project) #=> false
    def has_value?(option)
      self[option].not_nil?
    end    

    # Defaults options if they are not present.
    #
    #   prepared_options = PreparedOptions.new(:name => "yawningman", :project => nil)
    #   prepared_options.default! :zoom_level => 10, :project => "eschaton"
    #
    #   prepared_options[:zoom_level] #=> 10
    #   prepared_options[:project] #=> "eschaton"
    def default!(defaults)
      options.replace(defaults.merge(options))
    end

    # Validates that the given +options+ are present and do not have blank values.
    # If the validation fails, a ArgumentError will be raised indicating what required options 
    # are missing.
    #  
    #  prepared_options = PreparedOptions.new(:name => "yawningman", :project => nil)
    #
    #  prepared_options.validate_presence_of :name, :project #=> Raises ArgumentError
    #
    #  prepared_options[:project] = ''
    #  prepared_options.validate_presence_of :name, :project #=> Raises ArgumentError 
    #
    #  prepared_options[:project] = 'eschaton'
    #  prepared_options.validate_presence_of :name, :project #=> No error raised
    def validate_presence_of(*options)
      missing_options = options.select do |required_option|
                          self[required_option].blank?
                        end

      if missing_options.not_empty?
        raise ArgumentError, "The following options require values: #{missing_options.join(', ')}"
      end
    end

    # Yields the value for the given +option+ and updates the option to whatver the block returns.
    #
    #  # Instead of doing this
    #  prepared_options[:date] = Date.parse(prepared_options[:date])
    #
    #  # You can do this
    #  prepared_options.update(:date) do |date|
    #    Date.parse(date)
    #  end
    def update(option)
      self[option] = yield(self[option])
    end

    def inspect # :nodoc:
      output = "#{self.options.size} Options:\n"

      self.options.each do |option, value|
        output << "  #{option} => #{value.inspect}\n"
      end

      output
    end
    
    protected
      attr_accessor :options
  end  

end
