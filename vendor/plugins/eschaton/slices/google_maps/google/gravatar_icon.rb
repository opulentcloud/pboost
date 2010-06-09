require 'digest/md5'

module Google
  
  # Allows for a gravatar[http://www.gravatar.com/] to be used as a Google::Icon. 
  # Instead of using this directly see Map#add_marker with the +gravatar+ option.
  class GravatarIcon < Icon
    
    # See Gravatar#image_url for valid options.
    def initialize(options = {})
      options.default! :var => 'icon'

      # TODO - uses hashish goodness here!
      gravatar_options = {}
      gravatar_options[:email_address] = options.extract(:email_address) if options[:email_address]      
      gravatar_options[:size] = options.extract(:size) if options[:size]
      gravatar_options[:default] = options.extract(:default) if options[:default]

      options[:image] = self.image_url gravatar_options

      super
    end
    
    
    # Generates the url that represents the gravatar[http://www.gravatar.com/] icon.
    #
    # ==== Options:
    # * +email_address+ - Required. The email address of the gravatar
    # * +size+ - Optional. The size of the gravatar icon between 1 and 512 (pixels)
    # * +default+ - Optional. The default image to use should there be no gravatar for the given +email_address+
    def image_url(options)
      email_hash = Digest::MD5.hexdigest options.extract(:email_address)

      url_options = options.collect {|option, value|
                      "#{option}=#{value}"
                    }.join('&')

      url = "http://www.gravatar.com/avatar/#{email_hash}"
      url += "?#{url_options}" if url_options.not_blank?

      url
    end

  end
end