module Google
   
  class InfoWindow < MapObject
    attr_reader :object

    def initialize(options = {})
      # TODO - Find a better name than "object", maybe "anchored_to"
      @object = options.extract(:object)
      options[:var] = @object.var

      super
    end
    
    # TODO - The code in here sucks, sort it out
    def open(options)     
      options.default! :location => :center, :include_location => true

      location = Google::OptionsHelper.to_location(options[:location])
      location = self.object.center if location == :center      

      if options[:url]
        options[:location] = location
        
        # TODO - the way the jquery get forces use to duplicate code sucks, make OptionsHelper.to_content support URLS
        get(options) do |data|
          # TODO - this method call using both :content and :tabs options is ugly, also options not being reused.          
          open_info_window_on_map :location => location, :content => data, :tabs => options[:tabs]
        end        
      else
        # TODO - this method call using both :content and :tabs options is ugly, also options not being reused.
        open_info_window_on_map :location => location, :content => OptionsHelper.to_content(options), :tabs => options[:tabs]
      end
    end
    
    # TODO - The code in here sucks, sort it out    
    def open_on_marker(options)
      options.default! :include_location => true

      if options[:url]
        options[:location] = self.object.location
        
        # TODO - the way the jquery get forces use to duplicate code sucks, make OptionsHelper.to_content support URLS
        get(options) do |data|
          # TODO - this method call using both :content and :tabs options is ugly, also options not being reused.                    
          open_info_window_on_marker :content => data, :tabs => options[:tabs]
        end
      else
        # TODO - this method call using both :content and :tabs options is ugly, also options not being reused.         
        open_info_window_on_marker :content => OptionsHelper.to_content(options), :tabs => options[:tabs]
      end
    end
    
    def cache_on_marker(options)
      options.default! :include_location => true

      if options[:url]
        options[:location] = self.object.location

        # TODO - the way the jquery get forces use to duplicate code sucks, make OptionsHelper.to_content support URLS
        get(options) do |data|
          cache_info_window_for_marker :content => data
        end
      else
        cache_info_window_for_marker :content => OptionsHelper.to_content(options)
      end      
    end

    private
      def window_content(content)
        "\"<div id='info_window_content'>\" + #{content.to_js} + \"</div>\""
      end

      # TODO - This needs to be consolidated with open_info_window_on_map into a single, clear method
      def open_tabbed_info_window_on_map(options)
        create_info_window_tab_array options[:tabs]
        self << "#{self.var}.openInfoWindowTabs(#{options[:location]}, tabs);"      
      end

      # TODO - This needs to be consolidated with open_info_window_on_marker into a single, clear method
      def open_tabbed_info_window_on_marker(options)
        create_info_window_tab_array options[:tabs]
        self << "#{self.var}.openInfoWindowTabs(tabs);"      
      end

      def create_info_window_tab_array(tabs)
        self << "tabs = [];"
        
        tabs.each do |tab|
          content = Google::OptionsHelper.to_content(tab)
          self << "tabs.push(new GInfoWindowTab(#{tab[:label].to_js}, #{content.to_js}));"
        end  
      end

       # TODO - This method needs consolidation with open_tabbed_info_window_on_map into a single, clear method.
       #        Because this accepts both the :content and :tabs options it doesn't make clear what it does.
      def open_info_window_on_map(options)
        if options[:tabs]
          open_tabbed_info_window_on_map options
        else
          content = window_content options[:content]
          self << "#{self.var}.openInfoWindow(#{options[:location]}, #{content});"        
        end
      end

      # TODO - The code in here sucks, sort it out
      def open_info_window_on_marker(options)
        if options[:tabs]
          open_tabbed_info_window_on_marker options          
        else
          content = window_content options[:content]
          self << "#{self.var}.openInfoWindow(#{content});"
        end
      end

      def cache_info_window_for_marker(options)
        content = window_content options[:content]
        self << "#{self.var}.bindInfoWindowHtml(#{content});"
      end

      def get(options)
        if options[:include_location] == true
          options[:url][:location] = Google::UrlHelper.encode_location(options[:location])
        end

        self.script.get(:url => options[:url]) do |data|
          yield data
        end
      end

  end
end