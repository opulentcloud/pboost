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
  
  def gis_new_init_map
    run_map_script do
			
      map = Google::Map.new(:controls => [:small_map, :map_type],
                            :center => {:latitude => current_political_campaign.lat, :longitude => current_political_campaign.lng},
                            :zoom => 13)
      map.enableScrollWheelZoom
			map.clear_overlays
			
			polygon = Google::Polygon.new(:vertices => [], :fill_colour => 'yellow', :border_colour => 'green')
			overlay = map.add_overlay(polygon)
			polygon.enable_drawing
			polygon.enable_editing

	    polygon.click do |script, location|
	    	map.open_info_window( :url => { :controller => :gis_regions, :action => :create }, :location => :location)
	    end

			polygon.edited do |script|
				script.post :url => { :controller => :gis_regions, :action => :add_vertices, 
					:vertices => Google::UrlHelper.encode_vertices(polygon)}
			end

    end
  end
    
end
