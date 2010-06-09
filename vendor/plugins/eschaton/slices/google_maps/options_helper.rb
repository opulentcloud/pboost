module Google
  
  # Provides translation to the relevant Google mapping objects when working with method options.
  class OptionsHelper
    
    def self.to_location_array(locations)  # TODO - test
      if locations.is_a?(Array)
        google_locations = locations.collect {|location| Google::OptionsHelper.to_location(location)}            
        "[#{google_locations.join(', ')}]"
      else
        locations
      end
    end
    
    def self.to_vertices(vertices) # TODO - test
      if vertices.is_a?(Symbol) || vertices.is_a?(String)
        vertices
      else
        vertices.arify.collect do |vertex|
          Google::OptionsHelper.to_location(vertex)
        end
      end      
    end
    
    # TODO - Support URLS here
    def self.to_content(options) # :nodoc:
      if options[:partial]
        Eschaton.current_view.render options
      elsif options[:javascript]
        Eschaton.global_script << "var javascript = #{options[:javascript]};"

        :javascript
      else
        options[:text] || options[:html]
      end
    end
    
    def self.to_polygon(options) # :nodoc:
      if options.is_a?(Google::Polygon)
        options
      else
        Google::Polygon.new options
      end
    end
    
    def self.to_ground_overlay(options) # :nodoc:
      if options.is_a?(Google::GroundOverlay)
        options
      else
        Google::GroundOverlay.new options
      end
    end
    
    def self.to_circle(options) # :nodoc:
      if options.is_a?(Google::Circle)
        options
      else
        Google::Circle.new options
      end
    end
    
    def self.to_icon(options) # :nodoc:
      if options.is_a?(Google::Icon)
        options
      elsif options.is_a?(String) || options.is_a?(Symbol)
        Google::Icon.new :image => options        
      else
        Google::Icon.new options
      end
    end
    
    def self.to_location(options) # :nodoc:
      if options.is_a?(Google::Location) || options.is_a?(Symbol) || options.is_a?(String)
        options
      elsif options.is_a?(Array)
        Google::Location.new :latitude => options.first, :longitude => options.second        
      elsif options.is_a?(Hash)
        Google::Location.new options
      end
    end
    
    def self.to_bounds(options) # :nodoc:
      if options.is_a?(Google::Bounds)
        options
      elsif options.is_a?(Array)
        Google::Bounds.new :south_west_point => options.first, :north_east_point => options.second
      elsif options.is_a?(Hash)
        Google::Bounds.new options
      end
    end
    
    # ==== Options:
    # * +existing+ - Optional. Indicates if the marker is an existing marker.
    def self.to_marker(options) # :nodoc:
      if options.is_a?(Hash) && options[:existing] == true
        Google::Marker.existing options
      elsif options.is_a?(Hash)
        Google::Marker.new options
      elsif options.is_a?(Symbol)
        Google::Marker.existing :var => options
      else
        options
      end
    end
    
    def self.to_line(options) # :nodoc:
      if options.is_a?(Hash)
        Google::Line.new options
      else
        options
      end
    end

    def self.to_image(image) # :nodoc:
      if image.is_a?(Symbol)
        "/images/#{image}.png"        
      elsif image.is_a?(String)
        image
      end
    end

    def self.to_gravatar_icon(options) # :nodoc:
      if options.is_a?(String)
        Google::GravatarIcon.new :email_address => options
      elsif options.is_a?(Hash)
        Google::GravatarIcon.new options
      end
    end
    
    def self.to_google_position(options) # :nodoc:
      if options.not_blank?
        options.default! :anchor => :top_right, :offset => [0, 0]

        anchor = Google::OptionsHelper.to_google_anchor(options[:anchor])
        offset = Google::OptionsHelper.to_google_size(options[:offset])

        "new GControlPosition(#{anchor}, #{offset})"        
      end
    end
    
    def self.to_encoded_polyline(options) # :nodoc:
      options.to_google_options(:quote => [:points, :levels])
    end
    
    def self.to_encoded_polylines(options) # :nodoc:
      lines = options.extract(:lines)
      style_options = options

      # The first line's style will be used for all line styles
      lines.first.merge!(style_options)

      polylines = lines.collect do |encoded_polyline|
                    self.to_encoded_polyline encoded_polyline
                  end

      "[#{polylines.join(', ')}]"
    end
    
    # Converts a +symbol+ into an appropriate Google maps MapType constant[http://code.google.com/apis/maps/documentation/reference.html#GMapType]
    #
    # ==== Example conversions    
    #
    #  :normal       => G_NORMAL_MAP
    #  :satellite    => G_SATELLITE_MAP
    #  :hybrid       => G_HYBRID_MAP
    #  :physical     => G_PHYSICAL_MAP
    #  :mars_visible => G_MARS_VISIBLE_MAP
    #
    #  and so on ...
    def self.to_map_type(symbol)
      "G_#{symbol.to_s.upcase}_MAP".to_sym
    end
    
    # Converts a +symbol+ into an appropriate Google maps control[http://code.google.com/apis/maps/documentation/reference.html#GControlImpl]
    #
    # ==== Example conversions
    #
    #  :small_map     => GSmallMapControl
    #  :scale         => GScaleControl
    #  :map_type      => GMapTypeControl, 
    #  :overview_map  => GOverviewMapControl
    #  :large_map_3D  => GLargeMapControl3D
    #  :small_zoom_3D => GSmallZoomControl3D
    #
    #  and so on ...
    def self.to_google_control(symbol)
      control_class = "G#{symbol.to_s.classify}"
      control = if /3D$/ =~ control_class # Support for 3D controls
                  "#{control_class.gsub('3D', '')}Control3D"
                else
                  "#{control_class}Control"
                end

      control.to_sym              
    end

    def self.to_google_anchor(anchor)
      "G_ANCHOR_#{anchor.to_s.upcase}".to_sym
    end    

    # Converts the array to a google size[http://code.google.com/apis/maps/documentation/reference.html#GSize]. The +first+ 
    # element of the array represents the +width+ and the +second+ element represents the +height+.
    #
    # ==== Examples:
    #
    #  OptionsHelper.to_google_size([10, 10])   #=> "new GSize(10, 10)"
    #  OptionsHelper.to_google_size([100, 50])  #=> "new GSize(100, 50)"
    #  OptionsHelper.to_google_size([200, 150]) #=> "new GSize(200, 150)"
    def self.to_google_size(array)
      "new GSize(#{array.first}, #{array.second})"
    end

  end

end