module MapHelper
  
  def init_map
    run_map_script do
			
      map = Google::Map.new(:controls => [:small_map, :map_type],
                            :center => {:latitude => session[:geo_location].lat, :longitude => session[:geo_location].lng},
                            :zoom => 13)
      #map.enableScrollWheelZoom
			map.clear_overlays
			#map.enable_google_bar!
			
			polygon = Google::Polygon.new(:vertices => [], :fill_colour => 'yellow', :border_colour => 'green')
			overlay = map.add_overlay(polygon)
			polygon.enable_drawing
			polygon.enable_editing

#      map.add_polygon :vertices => Area.first.to_vertices_array,
#      	:fill_colour => 'yellow', :border_colour => 'green', :editable => true

#      map.add_polygon :vertices => Area.find(2).to_vertices_array,
#      	:fill_colour => 'blue', :border_colour => 'green'
#      map.add_polygon :vertices => Area.find(3).to_vertices_array,
#      	:fill_colour => 'purple', :border_colour => 'green'
      
      #map.add_polygon :vertices => [[39.3598516311347,-76.6781544685364],[39.3666368582996,-76.6608381271362],[39.3612120473572,-76.6553664207458],[39.3570643541746,-76.6749358177185],[39.3598516311347,-76.6781544685364]],
#      	:fill_colour => 'yellow', :border_colour => 'green'
      	
			#kml = new GGeoXml("http://localhost:3000/areas/1.kml")
			#map.add_overlay(kml)
			#geometryControls = map.add_control :geometry
			#geometryControls.add_control :marker
			#map.add_control(geometryControls)
			#map.add_control :shape

#      polygon.click do |script, location|
#      	#map.add_vertex :location => location
#      	map.open_info_window( :url => { :action => 'add_marker' }, :location => location)
        #map.open_info_window(:location => location, :html => "Hello #{session[:geo_location].city}")
#      end

			polygon.edited do |script|
				script.post :url => { :action => :add_polygon, 
					:vertices => Google::UrlHelper.encode_vertices(polygon)}
			end

      map.click do |script, location|
      	#map.open_info_window( :url => { :action => 'add_vertex' }, :location => location)
      	#polygon.add_vertex :location => location
      	#map.open_info_window( :url => { :action => 'add_marker' }, :location => location)
        #map.open_info_window(:location => location, :html => "Hello #{session[:geo_location].city}")
      end
    end
  end
  
end
