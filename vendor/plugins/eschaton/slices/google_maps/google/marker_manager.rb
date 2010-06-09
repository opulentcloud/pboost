module Google
   
  # Allows for only showing markers that are visible within the current zoom level and current bounds of the map, which leads to an increase in performance when adding many markers to the map.
  #
  # For example if 10,000 markers are distributed over a large area and only 200 fall within the current zoom level and current bounds of the map, only those 200 will be shown. When zooming or moving the map further, markers will be show in relation to that area only.
  #
  # Also effective for grouping markers in order to show, hide or toggle the groups visibility.
  #
  # If a method or event is not documented here please see the online[http://gmaps-utility-library-dev.googlecode.com/svn/tags/markermanager/1.1/docs/reference.html] docs for details
  # 
  # ==== Examples:
  #
  #  marker_manager = map.add_marker_manager
  #
  #  marker_manager.add_marker :location => {:latitude => -33.947, :longitude => 18.462}
  #  marker_manager.add_marker :location => {:latitude => -33.979, :longitude => 18.465}
  #  marker_manager.add_marker :location => {:latitude => -33.999, :longitude => 18.469}
  #
  # ==== Example with options:
  #
  #  marker_manager = map.add_marker_manager :border_padding => 100, :maximum_zoom => 20, :track_markers => true
  #
  #  marker_manager.add_marker :location => {:latitude => -33.947, :longitude => 18.462}
  #  marker_manager.add_marker :location => {:latitude => -33.979, :longitude => 18.465}
  #  marker_manager.add_marker :location => {:latitude => -33.999, :longitude => 18.469}
  #
  # ==== Toggle Example:
  #
  #  # You could toggle the visiblit when the map is clicked  
  #  map.clicked do
  #    marker_manager.toggle
  #  end
  class MarkerManager < MapObject
    
    # Use Map#add_marker_manager to create a new MarkerManager.
    #
    # ==== Options:
    # * +border_padding+ Optional. Specifies, in pixels, the extra padding outside the map's current viewport monitored by a manager. Markers that fall within this padding are added to the map, even if they are not fully visible.
    # * +maximum_zoom+  Optional. Sets the maximum zoom level monitored by the marker manager. This value is also used when markers are added to the manager using add_marker without the optional +maximum_zoom+ parameter. Defaulted to the maximum map zoom level.
    # * +track_markers+ Optional. Indicates whether or not the marker manager should track markers' that are moved by calling Marker#move_to. Defaulted to +false+.   
    def initialize(options = {})
      super

      # TODO - user prepared options and call rename
      options[:max_zoom] = options.extract(:maximum_zoom) if options.has_key?(:maximum_zoom)

      if self.create_var?
        self << "#{self.var} = new MarkerManager(#{Google::current_map}, #{options.to_google_options});"
      end
    end

    # Adds a marker to the manager.
    # 
    # ==== Options:
    # 
    #  If you want to supply the +minimum_zoom+ and +maximum_zoom+ options the +marker+ option must be supplied. 
    #  +marker_or_options+ can also be a Marker or whatever Marker#new supports in which case +minimum_zoom+ and +maximum_zoom+ will be defaulted.
    #
    # * +marker+ - Optional. A Marker or whatever options Marker#new supports.
    # * +minimum_zoom+ - Optional. The minimum zoom that this marker will be monitored by the manager. Defaulted to 1.
    # * +maximum_zoom+ - Optional. The maximum zoom that this marker will be monitored by the manager. Defaulted to the maximum map zoom level.
    def add_marker(marker_or_options = {})
      options = if marker_or_options.is_a?(Google::Marker)
                  {:marker => marker_or_options}
                elsif marker_or_options.has_key?(:marker)
                  marker_or_options
                else
                  {:marker => marker_or_options}
                end

      options.default! :minimum_zoom => 1, :maximum_zoom => nil

      marker = Google::OptionsHelper.to_marker(options[:marker])

      arguments = [marker, options[:minimum_zoom], options[:maximum_zoom]]

      self << "#{self.var}.addMarker(#{arguments.to_compact_js_arguments})"
    end
    
    # Adds markers to the manager. +markers_or_options+ is an array of options that add_marker supports
    def add_markers(markers_or_options)
      markers_or_options.each do |marker_or_options|
        self.add_marker marker_or_options
      end
    end

  end
end