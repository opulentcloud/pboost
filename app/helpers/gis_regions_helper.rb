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
end
