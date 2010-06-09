module Google # :nodoc:
  
  # Represents a map. If a method or event is not documented here please see googles online[http://code.google.com/apis/maps/documentation/reference.html#GMap2] 
  # docs for details. See MapObject#listen_to on how to use events not listed on this object.
  #
  # You will most likely use click, open_info_window, add_line, add_marker and add_markers to get some basic functionality going.
  #
  # === Examples:
  #
  #  Google::Map.new # On the mushroom dotted plains of Afffrrrricaaaaa!
  #
  #  Google::Map.new :center => :best_fit
  #
  #  Google::Map.new :zoom => 8
  #
  #  Google::Map.new(:center => {:latitude => -33.947, :longitude => 18.462})
  # 
  #  Google::Map.new(:center => {:latitude => -33.947, :longitude => 18.462}, 
  #                  :controls => [:small_map, :map_type])
  #
  #  Google::Map.new(:center => {:latitude => -33.947, :longitude => 18.462}, 
  #                  :controls => [:small_map, :map_type],
  #                  :zoom => 12)
  #
  #  Google::Map.new(:center => {:latitude => -33.947, :longitude => 18.462}, 
  #                  :controls => [:small_map, :overview_map],
  #                  :zoom => 12, 
  #                  :type => :satellite)
  #
  # === Using the click event:
  #
  #  # When the map is clicked, add a marker and open an info window at that location   
  #  map.click do |script, location|
  #    map.add_marker :location => location
  #    map.open_info_window :location => location, :html => 'Awesome, you added a marker!'
  #  end
  #
  # === Adding markers using add_marker:
  #
  #  map.add_marker :location => {:latitude => -34, :longitude => 18.5}
  #
  #  map.add_marker :location => {:latitude => -34, :longitude => 18.5}, 
  #                 :draggable => true,
  #                 :title => "This is a marker!"
  #
  #  map.add_marker :location => {:latitude => -34, :longitude => 18.5},
  #                 :icon => :green_circle
  #
  # === Info windows using open_info_window:
  #
  #  # At a specific location
  #  map.open_info_window :location => {:latitude => -34, :longitude => 18.5},
  #                       :html => 'Hello there...'
  # 
  #  # In the center of the map
  #  map.open_info_window :location => :center, :html => 'Hello there...'
  #  
  #  # Now using partial
  #  map.open_info_window :location => :center, :partial => 'spot_information',
  #
  #  map.open_info_window :location => :center, :partial => 'spot_information', :locals => {:information => information}
  #
  #  # Using a url, will include the location info in the url
  #  # Use params[:location] or params[:location][:latitude] and params[:location][:longitude] in your action
  #  map.open_info_window :locals => :center, :url => {:controller => :spot, :action => :show, :id => @spot}
  #
  #  # Don't include the location in the params
  #  map.open_info_window :locals => :center, :url => {:controller => :spot, :action => :show, :id => @spot},
  #                       :include_location => false
  #
  #  # Open a info window with two tabs created using the :html tab option
  #  map.open_info_window :location => {:latitude => -34, :longitude => 18.5},
  #                       :tabs => [{:label => 'First tab', :html => 'This is the first tab, nice!'},
  #                                 {:label => 'Second tab', :html => 'This is the second tab, wow!'}]
  #
  #  # Open a info window with two tabs one created using the :html tab option and the other using a partial
  #  map.open_info_window :location => {:latitude => -34, :longitude => 18.5},
  #                       :tabs => [{:label => 'Your info', :html => 'This is an info tab!'},
  #                                 {:label => 'Account Info', :partial => 'account/info'}]  
  # 
  # === Using lines with add_line
  #
  #  map.add_line :vertices => [{:latitude => -33.958, :longitude => 18.462},
  #                             {:latitude => -33.987, :longitude => 18.462},
  #                             {:latitude => -33.999, :longitude => 18.472}]
  #
  #  map.add_line :from => {:latitude => -33.958, :longitude => 18.462},
  #               :to => {:latitude => -33.987, :longitude => 18.462}
  #
  #  map.add_line :from => {:latitude => -33.958, :longitude => 18.462},
  #               :to => {:latitude => -33.987, :longitude => 18.462},
  #               :colour => 'red', :thickness => 20
  #
  #  # Adding a line betweem markers
  #  markers = map.add_markers({:location => {:latitude => -33.958, :longitude => 18.462}},
  #                            {:location => {:latitude => -33.987, :longitude => 18.462}},
  #                            {:location => {:latitude => -33.999, :longitude => 18.472}})
  #
  #  map.add_line :between_markers => markers, :colour => 'red', :thickness => 10  
  class Map < MapObject
    attr_reader :zoom, :type, :track_bounds

    # ==== Options: 
    # * +center+ - Optional. Centers the map at this location defaulted to <tt>:best_fit</tt>, see center= for valid options.
    # * +controls+ - Optional. Which controls will be added to the map, see controls= for details, defaulted to [:large_map_3D, :map_type]
    # * +zoom+ - Optional. The zoom level of the map defaulted to <tt>:best_fit</tt>, see zoom=.
    # * +type+ - Optional. The type of map, see type=.
    # * +keyboard_navigation+ - Optional. Indicates if
    #   {keyboad navigation}[http://code.google.com/apis/maps/documentation/reference.html#GKeyboardHandler] should be enabled, defaulted to +false+.
    def initialize(options = {})
      options.default! :var => 'map', :center => :best_fit, 
                       :controls => [:large_map_3D, :map_type],
                       :zoom => :best_fit,
                       :keyboard_navigation => false

      super

      options.assert_valid_keys :center, :controls, :zoom, :type, :keyboard_navigation
      
      Google.current_map = self
      
      self.track_bounds!

      if self.create_var?
        Google::Scripts.before_map_script << "var map;" # For IE Fix

        script << "map_lines = new Array();"
        script << "#{self.var} = new GMap2(document.getElementById('#{self.var}'));" 

        self.center = options.extract(:center)
        self.zoom = options.extract(:zoom)        
        self.enable_keyboard_navigation! if options.extract(:keyboard_navigation)
        
        self.track_last_mouse_location!
        
        self.options_to_fields options
      end
    end

    # Sets the type of map to display. See OptionsHelper.to_map_type for how values are translated and review google maps 
    # supported[http://code.google.com/apis/maps/documentation/reference.html#GMapType] map types.
    #
    # ==== Examples:
    #
    #  map.type = :satellite
    #  map.type = :hybrid
    #  map.type = :physical
    #  map.type = :sky_visible
    def type=(value)
      @type = value
      self << "#{self.var}.setMapType(#{Google::OptionsHelper.to_map_type(value)});"
    end
    
    # Removes map +types+ from the map. See the map type contants[http://code.google.com/apis/maps/documentation/reference.html#GMapType]
    # section of google online docs for supported map types.    
    #
    # ==== Examples:
    #   map.remove_type :satellite
    #   map.remove_type :normal, :satellite    
    def remove_type(*types)
      types.each do |type|
        self.remove_map_type Google::OptionsHelper.to_map_type(type)
      end
    end    

    # Centers the map at the given +location+ which can be <tt>:best_fit</tt>, a Location or whatever Location#new supports.
    # If set to <tt>:best_fit</tt> google maps will determine an appropriate center location.
    # 
    # ==== Examples:
    #  map.center = :best_fit
    #
    #  map.center = {:latitude => -34, :longitude => 18.5}
    #
    #  map.center = Google::Location.new(:latitude => -34, :longitude => 18.5)
    def center=(location)
      location = Google::OptionsHelper.to_location(location)

      if location == :best_fit
        self.center = self.default_center
        Google::Scripts.end_of_map_script do
          self.auto_center!          
        end
      else
        self.set_center location
      end
    end

    # Automatically centers the map to the appropriate location based on all overlays added to the map.
    # In order to be effective this *must* be called after you have added all your overlays to the map.
    #
    # ==== Examples:
    #
    #  map.add_marker :location => {:latitude => -34.947, :longitude => 18.462}
    #  map.add_marker :location => {:latitude => -70.947, :longitude => 19.462}
    #
    #  map.auto_center!
    def auto_center!
      self << "if(!#{self.track_bounds}.isEmpty()){
                 #{self}.setCenter(#{self.track_bounds.center});
              }"
    end

    def center
      "#{self}.getCenter()"
    end
    
    # Sets the zoom level of the map, +zoom+ can be a number(1 - 22) or <tt>:best_fit</tt>. If set to <tt>:best_fit</tt> 
    # google maps will determine an appropriate zoom level.
    #
    # ==== Examples:
    #  map.zoom = :best_fit
    #
    #  map.zoom = 12
    def zoom=(zoom)
      @zoom = zoom

      if zoom == :best_fit
        Google::Scripts.end_of_map_script do
          self.auto_zoom!
        end
      else
        self.set_zoom(self.zoom)    
      end
    end
    
    # Automatically zooms the map to the appropriate level based on all overlays added to the map.
    # In order to be effective this *must* be called after you have added all your overlays to the map.
    #
    # ==== Examples:
    #
    #  map.add_marker :location => {:latitude => -34.947, :longitude => 18.462}
    #  map.add_marker :location => {:latitude => -70.947, :longitude => 19.462}
    #
    #  map.auto_zoom!
    def auto_zoom!
      self << "#{self}.setZoom(#{self}.getBoundsZoomLevel(#{self.track_bounds}));"
    end
    
    # Automatically zooms the map to the appropriate level and centers the map to the appropriate location based on all overlays added to the map.
    # In order to be effective this *must* be called after you have added all your overlays to the map.
    #
    # ==== Examples:
    #
    #  map.add_marker :location => {:latitude => -34.947, :longitude => 18.462}
    #  map.add_marker :location => {:latitude => -70.947, :longitude => 19.462}
    #
    #  map.auto_fit!
    def auto_fit!
      self.auto_zoom!      
      self.auto_center!
    end

    # The last location of the mouse. If the mouse has not moved the map center will be used.
    def last_mouse_location
      :last_mouse_location
    end

    # Adds the +control+ to the map, see OptionsHelper.to_google_control for how +control+ will be translated.
    #
    # ==== Options:
    # * +position+ - Optional. The position that the control should be placed.
    #
    # ==== Examples:
    #  map.add_control :small_zoom
    #  map.add_control Google::Pane.new(:html => 'This is a pane')
    #  map.add_control :small_zoom, :position => {:anchor => :top_right}
    #  map.add_control :map_type, :position => {:anchor => :top_left}
    #  map.add_control :map_type, :position => {:anchor => :top_left, :offset => [10, 10]}
    def add_control(control, options = {})
      control = "new #{Google::OptionsHelper.to_google_control(control)}()" if control.is_a?(Symbol)
      position = Google::OptionsHelper.to_google_position options[:position]
      arguments = [control, position].compact

      script << "#{self.var}.addControl(#{arguments.join(', ')});"
    end

    # Adds a control or controls to the map, see OptionsHelper.to_google_control for how +controls+ will be translated.
    # The controls will all be placed at their default positions, if you need control over the position use add_control.   
    #
    # ==== Examples:
    #  map.controls = :small_zoom
    #  map.controls = :small_zoom, :map_type
    #  map.controls = :small_zoom, Google::Pane.new(:html => 'This is a pane')    
    def controls=(*controls)
      controls.flatten.each do |control|
        self.add_control control
      end
    end

    # Adds a pane with the given +options+ which can be anything Google::Pane supports.
    def add_pane(options)
      self.add_control Google::Pane.new(options)
    end

   # Creates a MarkerClusterer with the given +options+, see Google::MarkerClusterer.new for valid +options+.
   def add_marker_clusterer(options = {})
     Google::MarkerClusterer.new options
   end

   # Creates a MarkerManager with the given +options+, see Google::MarkerManager.new for valid +options+.
   def add_marker_manager(options = {})
     Google::MarkerManager.new options
   end
    
    # Replaces an existing marker on the map.
    def replace_marker(marker_or_options)
      remove_options = if marker_or_options.is_a?(Hash)
                         marker_or_options.merge :existing => true
                       else
                         marker_or_options
                       end

      remove_marker remove_options
      add_marker marker_or_options
    end

    # Changes the +exsitng_marker+ with the given +marker_or_options+
    def change_marker(exsitng_marker, marker_or_options)
      remove_marker exsitng_marker
      add_marker marker_or_options
    end

    # Adds a single marker to the map which can be a Marker or whatever Marker#new supports.
    #
    # ==== Examples:
    #
    #  map.add_marker :location => {:latitude => -34, :longitude => 18.5}
    #
    #  map.add_marker :location => {:latitude => -34, :longitude => 18.5}, 
    #                 :draggable => true,
    #                 :title => "This is a marker!"
    #
    #  map.add_marker :location => {:latitude => -34, :longitude => 18.5},
    #                 :icon => :green_circle
    def add_marker(marker_or_options)
      marker = Google::OptionsHelper.to_marker(marker_or_options)

      self.add_overlay marker
      marker.added_to_map self

      self.track_bounds.extend marker.location

      marker      
    end

    # Adds markers to the map. Each marker in +markers+ can be a Marker or whatever Marker#new supports.
    def add_markers(*markers_or_options)
      markers_or_options.flatten.collect do |marker_or_options|
        add_marker marker_or_options
      end
    end
    
    # Removes a marker that has already been placed on the map.
    def remove_marker(marker_or_options)
      marker = OptionsHelper.to_marker(marker_or_options)

      self.remove_overlay marker
      marker.removed_from_map(self)
    end

    # Adds a +line+ to the map which can be a Line or whatever Line#new supports.
    #
    # ==== Examples:
    #  map.add_line :vertices => [{:latitude => -33.958, :longitude => 18.462},
    #                             {:latitude => -33.987, :longitude => 18.462},
    #                             {:latitude => -33.999, :longitude => 18.472}]
    #
    #  map.add_line :from => {:latitude => -33.958, :longitude => 18.462},
    #               :to => {:latitude => -33.987, :longitude => 18.462}
    #
    #  map.add_line :from => {:latitude => -33.958, :longitude => 18.462},
    #               :to => {:latitude => -33.987, :longitude => 18.462},
    #               :colour => 'red', :thickness => 20
    #
    #  # Adding a line betweem markers
    #  markers = map.add_markers({:location => {:latitude => -33.958, :longitude => 18.462}},
    #                            {:location => {:latitude => -33.987, :longitude => 18.462}},
    #                            {:location => {:latitude => -33.999, :longitude => 18.472}})
    #
    #  map.add_line :between_markers => markers, :colour => 'red', :thickness => 10
    def add_line(line)
      line = Google::OptionsHelper.to_line(line)

      self.add_overlay line
      line.added_to_map self

      self << "map_lines.push(#{line});"      
      
      unless line.encoded?
        self.track_bounds.extend *line.vertices 
      end

      line
    end

    # Removes a +line+ from the map.
    def remove_line(options)
      line = Google::OptionsHelper.to_line(options)

      self.remove_overlay line
      line.removed_from_map self      
    end

    # Removes all lines from the map that where added using add_line.
    def remove_lines!
      self << "for(var i = 0; i < map_lines.length; i++){"
      self.remove_overlay 'map_lines[i]'
      self << "}"
    end

    # Adds a +polygon+ to the map which can be a Polygon or whatever Polygon#new supports.
    def add_polygon(options)
      polygon = Google::OptionsHelper.to_polygon(options)
      
      self.add_overlay polygon
      polygon.added_to_map self
      
      unless polygon.encoded?
        self.track_bounds.extend polygon.vertices
      end
      
      polygon
    end
    
    # Removes a +polygon+ from the map.
    def remove_polygon(options)
      polygon = Google::OptionsHelper.to_polygon(options)
      
      self.remove_overlay polygon
      polygon.removed_from_map self      
    end
    
    # Adds a +ground_overlay+ to the map which can be a GroundOverlay or whatever GroundOverlay#new supports.
    def add_ground_overlay(options)
      ground_overlay = Google::OptionsHelper.to_ground_overlay(options)

      self.add_overlay ground_overlay

      self.track_bounds.extend ground_overlay.bounds

      ground_overlay
    end
    
    # Removes a +ground_overlay+ from the map.
    def remove_ground_overlay(options)
      ground_overlay = Google::OptionsHelper.ground_overlay(options)
      
      self.remove_overlay ground_overlay
    end
    
    # Adds a +circle+ to the map which can be a Circle or whatever Circle#new supports.    
    def add_circle(options)
      circle = OptionsHelper.to_circle(options)
      self.add_overlay circle

      circle
    end
    
    # Adds a KML[http://en.wikipedia.org/wiki/Keyhole_Markup_Language] overlay using the given +url+.
    def add_kml(url)
      script << "map.addOverlay(new GGeoXml(#{url.to_js}));"
    end

    # Removes the given +overlay+ from the map.
    def remove_overlay(overlay)
      self << "#{self}.removeOverlay(#{overlay});"
    end

    # Clears all overlays(info windows, markers, lines etc) from the map.
    def clear
      self.clear_overlays
    end

    # If called with a block it will attach the block to the "click" event of the map.
    # If +info_window_options+ are supplied an info window will be opened with those options and the block will be ignored.
    #
    # This will only run if the map is clicked, not an info window or overlay.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    # * +location+ - The location at which the map was clicked.
    #
    # ==== Examples:
    #
    #  # When the map is clicked, add a marker and open an info window at that location   
    #  map.click do |script, location|
    #    map.add_marker :location => location
    #    map.open_info_window :location => location, :html => 'Awesome, you added a marker!'
    #  end
    #
    #  # Using the +info_window_options+ convenience
    #  map.click :html => 'Awesome, an info window popped up!'
    def click(info_window_options = nil)
      if info_window_options
        self.click do |script, location|
          self.open_info_window info_window_options.merge(:location => location)
        end
      elsif block_given?
        self.listen_to :event => :click, :with => [:overlay, :location] do |script, overlay, location|
          script << "if(location){"

          yield script, location

          script << "}"
        end
      end
    end

    # This event is fired when the mouse "moves over" the map.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    # * +location+ - The location at which the mouse cursor is hovering.
    def mouse_over(&block)
      self.listen_to :event => :mousemove, :with => :location, &block
    end

    # Opens an info window on the map at the given +location+ using either +url+, +partial+ or +html+ options as content or
    # if a +tabs+ option is provided, a tabbed info window.
    #
    # ==== Options:
    # * +location+ - Optional. A Location, whatever Location#new supports or :center which indicates where the info window 
    #   must be placed on the map, defaulted to +:center+.
    # * +url+ - Optional. URL is generated by rails #url_for. Supports standard url arguments and javascript variable interpolation.
    # * +include_location+ - Optional. Works in conjunction with the +url+ option and indicates if latitude and longitude parameters of
    #   +location+ should be sent through with the +url+, defaulted to +true+. Use <tt>params[:location]</tt> or <tt>params[:location][:latitude]</tt> and <tt>params[:location][:longitude]</tt> in your action.
    # * +partial+ - Optional. Supports the same form as rails +render+ for partials, content of the rendered partial will be 
    #   placed inside the info window.
    # * +html+ - Optional. The html content that will be placed inside the info window.
    # * +tabs+ - Optional. An array of tab options, each tab options represents a tab and should have the following keys:
    #   * +label+ - Required. The label for the tab, this will be displayed on the tab.
    #   * +html+ - Optional. The html content that will be placed inside the info window.    
    #   * +partial+ - Supports the same form as rails +render+ for partials, content of the rendered partial will be placed inside the tab.
    #
    # ==== Examples:
    #
    #  # At a specific location
    #  map.open_info_window :location => {:latitude => -34, :longitude => 18.5},
    #                       :html => 'Hello there...'
    # 
    #  # In the center of the map
    #  map.open_info_window :location => :center, :html => 'Hello there...'
    #  
    #  # Now using partial
    #  map.open_info_window :location => :center, :partial => 'spot_information',
    #
    #  map.open_info_window :location => :center, :partial => 'spot_information', :locals => {:information => information}
    #
    #  # Using a url, will include the location info in the url
    #  # Use params[:location] or params[:location][:latitude] and params[:location][:longitude] in your action
    #  map.open_info_window :locals => :center, :url => {:controller => :spot, :action => :show, :id => @spot}
    #
    #  # Don't include the location in the params
    #  map.open_info_window :locals => :center, :url => {:controller => :spot, :action => :show, :id => @spot},
    #                       :include_location => false
    #
    #  # Open a info window with two tabs created using the :html tab option
    #  map.open_info_window :location => {:latitude => -34, :longitude => 18.5},
    #                       :tabs => [{:label => 'First tab', :html => 'This is the first tab, nice!'},
    #                                 {:label => 'Second tab', :html => 'This is the second tab, wow!'}]
    #
    #  # Open a info window with two tabs one created using the :html tab option and the other using a partial
    #  map.open_info_window :location => {:latitude => -34, :longitude => 18.5},
    #                       :tabs => [{:label => 'Your info', :html => 'This is an info tab!'},
    #                                 {:label => 'Account Info', :partial => 'account/info'}]
    def open_info_window(options)
      info_window = InfoWindow.new(:object => self)
      info_window.open options
    end
    
    # This event is fired after an info window has been opened on the map.
    #
    # ==== Yields:
    # * +script+ - A JavaScriptGenerator to assist in generating javascript or interacting with the DOM.
    def after_info_window_opened(&block)
      self.listen_to :event => :infowindowopen, &block
    end

    # Updates the contents of an existing info window. This supports the relevant content options of open_info_window. 
    def update_info_window(options)
      options[:location] = "#{self}.getInfoWindow().getPoint()"

      self.open_info_window options
    end
    
    # Opens an info window at the given +location+ that contains a blowup view of the map around the +location+.
    #
    # ==== Options:
    # * +location+ - Required. The location at which the the blowup must be placed.
    # * +zoom_level+ - Optional. Sets the blowup to a particular zoom level.
    # * +map_type+ - Optional. Set the type of map shown in the blowup.
    def show_blowup(options = {})
      options[:map_type] = Google::OptionsHelper.to_map_type(options[:map_type]) if options[:map_type]
      location = Google::OptionsHelper.to_location(options.extract(:location))
      
      self << "#{self.var}.showMapBlowup(#{location}, #{options.to_google_options});" 
    end

    # The default center for the map which is Mzanzi.
    def default_center # :nodoc:
      {:latitude => -33.947, :longitude => 18.462}
    end
    
    def bounds
      Google::Bounds.existing :var => "#{self}.getBounds()"
    end
    
    protected
      attr_writer :track_bounds
      
      def enable_keyboard_navigation! # :nodoc:
        self << "new GKeyboardHandler(#{self})"  
      end

      def track_bounds! # :nodoc:
        self.track_bounds = if self.create_var?
                              Google::Bounds.new(:var => :track_bounds)
                            else
                              Google::Bounds.existing(:var => :track_bounds)
                            end
      end

      def track_last_mouse_location! # :nodoc:
        self << "last_mouse_location = #{self.center};"

        self.mouse_over do |script, location|
          script << "last_mouse_location = #{location};"
        end
      end
  end
end
