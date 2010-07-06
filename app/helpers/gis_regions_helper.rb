module GisRegionsHelper

  def gis_show_init_map
    run_map_script do
			
      map = Google::Map.new(:controls => [:small_map, :map_type],
                            :center => {:latitude => @gis_region.geom.envelope.center.x, :longitude => @gis_region.geom.envelope.center.y },
                            :zoom => 13)
      map.enableScrollWheelZoom
			map.clear_overlays
			
      map.add_polygon(:vertices => @gis_region.to_vertices_array,
      	:fill_colour => 'yellow', :border_colour => 'green', :editable => false, :tooltip => { :text => @gis_region.name })

    end
  end

	def init_new_poly
		run_javascript do |script|
			script << "function init_new_poly(){"
			script << "	polygon_index++;"
			script << "var color_index = [\"yellow\",\"orange\",\"blue\",\"purple\",\"red\"];"

			map = script.map
			
			polygon = Google::Polygon.new(:vertices => [], :fill_colour => 'yellow', :border_colour => 'black')

			overlay = map.add_overlay(polygon)
			script << 'overlays[polygon_index] = polygon;'
			polygon.enable_drawing
			polygon.enable_editing

			map.click do |script, location|
				polygon.add_vertex(location)
			end

	    polygon.click do |script, location|
	    	map.open_info_window( :url => { :controller => :gis_regions, :action => :create, :sess_id => "#{@sess_id}", :vertices => Google::UrlHelper.encode_vertices(polygon) }, :location => :location)
	    end

			script << "};"
		end
	end
  
  def gis_new_init_map
    run_map_script do |mscript|
			
      map = Google::Map.new(:controls => [:small_map, :map_type],
                            :center => {:latitude => current_political_campaign.lat, :longitude => current_political_campaign.lng},
                            :zoom => 13)
      map.enableScrollWheelZoom
			map.clear_overlays

#			polygon.edited do |script|
#				script.post :url => { :controller => :gis_regions, :action => :add_vertices, :sess_id => "#{@sess_id}", :vertices => Google::UrlHelper.encode_vertices(polygon) }
#			end

    end
  end
    
end
