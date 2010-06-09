class Hash # :nodoc:
  
  # ==== Options
  # * +dont_convert+ - An array of keys that should *_not_* be converted to javascript.
  # * +quote+ - An array of keys that should *_not_* be converted to javascript but simply *_quoted_*.
  def to_google_options(options = {})
    dont_convert = (options[:dont_convert] || []).arify.collect(&:to_s)
    quote = (options[:quote] || []).arify.collect(&:to_s)
    string_keys = self.stringify_keys

    args = string_keys.keys.sort.collect do |key|
             value = if key.in?(dont_convert)
                       string_keys[key]
                     elsif key.in?(quote)
                       string_keys[key].quote
                     else
                       string_keys[key].to_js
                     end         
             
             "#{key.to_js_method}: #{value}"
           end

    "{#{args.join(', ')}}"
  end
  
end
