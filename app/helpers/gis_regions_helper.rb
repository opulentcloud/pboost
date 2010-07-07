module GisRegionsHelper

  def gis_show_init_map
    run_map_script do
			
      map = Google::Map.new(:controls => [:small_map, :map_type],
                            :center => {:latitude => @gis_region.geom.envelope.center.x, :longitude => @gis_region.geom.envelope.center.y },
                            :zoom => 15)
      map.enableScrollWheelZoom
			map.clear_overlays

			colors = Eschaton::JavascriptVariable.new(:name => :colors, :value => "[\"red\",\"blue\",\"orange\",\"purple\",\"yellow\",\"green\"]")

			@gis_region.geom2.each_with_index do |poly, index|	
			
		    map.add_polygon(:vertices => GisRegion.to_vertices_array(poly),
		    	:fill_colour => colors[index], :border_colour => 'black', :editable => false, :tooltip => { :text => @gis_region.name })
		    	
			end

    end
  end

	def init_delete_current_poly
		run_javascript do |script|
			script << "function delete_current_poly(){"		
			map = script.map
			script << 'poly = overlays.pop();'
			script << 'map.removeOverlay(poly);'
			script << 'polygon_index--;'
			script << "}"
		end	
	end

	def init_new_poly
		run_javascript do |script|
			script << "function init_new_poly(){"
			script << " if (polygon_index > 5) {"
			script << "	alert('Sorry, you can not have more than 6 routes on a single walksheet.');"
			script << " return;"
			script << "}"
			script << "	polygon_index++;"
			polygon_index = Eschaton::JavascriptVariable.existing(:var => :polygon_index)

			colors = Eschaton::JavascriptVariable.existing(:var => :colors)

			map = script.map
			
			polygon = Google::Polygon.new(:vertices => [], :fill_colour => colors[polygon_index], :border_colour => 'black')

			overlay = map.add_overlay(polygon)
			script << 'overlays[polygon_index] = polygon;'
			polygon.enable_drawing
			polygon.enable_editing

			map.click do |script, location|
				polygon.add_vertex(location)
			end

	    polygon.click do |script, location|
	    	map.open_info_window( :url => { :controller => :gis_regions, :action => :count_in_poly, :sess_id => "#{@sess_id}", :vertices => Google::UrlHelper.encode_vertices(polygon) }, :location => :location)
	    end

			script << "};"
		end
	end
  
  def init_save_current_polys
  	run_javascript do |script|
  		script << "function save_current_polys() {"
			map = script.map
  		script << "	vertices = new Array();"
  		script << " point = overlays[0].getVertex(0);"
  		#script << " alert(point.lat());"
			script << " vurl = '';"
  		script << "	for(var x=0;x<overlays.length;x++) {"
  		script << "		vertices.push(build_vertices(overlays[x]));"
  		#script << "	  alert(x);"
  		script << "	vurl += '&vertices_'+x+'='+vertices[x]"
  		script << "	}"
  		#script << " alert(vurl);"
			script << "	jQuery.get('/customer/create_polygon?location%5Blatitude%5D=' + point.lat() + '&location%5Blongitude%5D=' + point.lng() + vurl + '', function(data) { map.openInfoWindow(point, \"<div id='info_window_content'>\" + data + \"</div>\");});"
  		script << "}"
  	end
  end

	def init_update_map_precinct
		run_javascript do |script|
			script << "function update_map_precinct(ctrl) {"
			script << "	alert(ctrl.value);"
			script << "}"
		end
	end
  
  def gis_new_init_map
    run_map_script do |mscript|

      map = Google::Map.new(:controls => [:small_map, :map_type],
                            :center => {:latitude => current_political_campaign.lat, :longitude => current_political_campaign.lng},
                            :zoom => 13)
      map.enableScrollWheelZoom
			map.clear_overlays
		
			clusterer = map.add_marker_clusterer	
			
		precinct = current_political_campaign.municipal_district.precincts.first

		precinct.addresses.all(:conditions => 'geom is not null').each do |address|
			clusterer.add_marker :location => { :latitude => address.lat, :longitude => address.lng }	
		end

#			polygon.edited do |script|
#				script.post :url => { :controller => :gis_regions, :action => :add_vertices, :sess_id => "#{@sess_id}", :vertices => Google::UrlHelper.encode_vertices(polygon) }
#			end

    end
  end
    
end
