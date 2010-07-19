module MapHelper
  def show_init_map
    run_map_script do
			
      map = Google::Map.new(:controls => [:small_map, :map_type],
                            :center => {:latitude => @gis_region.geom.envelope.center.x, :longitude => @gis_region.geom.envelope.center.y },
                            :zoom => 15)
      map.enableScrollWheelZoom
			map.clear_overlays

			colors = Eschaton::JavascriptVariable.new(:name => :colors, :value => "[\"red\",\"blue\",\"orange\",\"purple\",\"yellow\",\"green\",\"gray\",\"pink\",\"cyan\",\"navy\"]")

			@gis_region.geom2.each_with_index do |poly, index|	
			
		    map.add_polygon(:vertices => GisRegion.to_vertices_array(poly),
		    	:fill_colour => colors[index], :border_colour => 'black', :editable => false, :tooltip => { :text => @gis_region.name })
		    	
			end

    end
  end

	def init_map_plot_precinct_cluster
		run_map_script do |script|
			#script << "<script type=\"text/javascript\">"

			map = script.map
			map.clear_overlays

			clusterer = map.add_marker_clusterer
			#clusterer = Eschaton::JavascriptVariable.existing(:var => :clusterer) 

			center_point = Eschaton::JavascriptVariable.existing(:var => :center_point) 

			@precinct.addresses.all(:conditions => 'geom is not null').each_with_index do |address,index|
				center_point = Google::Location.new(:latitude => address.lat, :longitude => address.lng) if index == 0
				clusterer.add_marker :location => { :latitude => address.lat, :longitude => address.lng }	
			end

			#script << "#{clusterer}"

			#reload any polygons they were drawing onto the map.
			overlays = Eschaton::JavascriptVariable.existing(:var => :overlays) 
			overlays.each do |polygon|
				overlay = map.add_overlay(polygon)
				#polygon.enable_drawing
				polygon.enable_editing
				
			end

			map.pan_to center_point
			#script << "</script>"
		end
	
	end

	def init_map_delete_current_poly
		run_javascript do |script|
			script << "function delete_current_poly(){"		
			map = script.map
			script << 'poly = overlays.pop();'
			script << 'map.removeOverlay(poly);'
			script << 'polygon_index--;'
			script << "}"
		end	
	end

	def init_map_new_poly
		run_javascript do |script|
			script << "function init_new_poly(){"
			script << " if (polygon_index > 9) {"
			script << "	alert('Sorry, you can not have more than 10 routes on a single walksheet.');"
			script << " return;"
			script << "}"
			script << "	polygon_index++;"
			polygon_index = Eschaton::JavascriptVariable.existing(:var => :polygon_index)

			colors = Eschaton::JavascriptVariable.existing(:var => :colors)

			map = script.map
			
			polygon = Google::Polygon.new(:vertices => [], :fill_colour => colors[polygon_index], :border_colour => 'black')

			overlay = map.add_overlay(polygon)
			script << 'overlays.push(polygon);'
			polygon.enable_drawing
			polygon.enable_editing

			map.click do |script, location|
				polygon.add_vertex(location)
			end

	    polygon.click do |script, location|
	    	map.open_info_window( :url => { :controller => :gis_regions, :action => :count_in_poly, :vertices => Google::UrlHelper.encode_vertices(polygon), :sess_id => "#{@sess_id}" }, :location => :location)
	    end

			script << "};"
		end
	end
  
  def init_map_save_current_polys
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

	def init_map_update_map_precinct
		run_javascript do |script|
			script << "function update_map_precinct(ctrl) {"
			#script << "	alert(ctrl.value);"
			script << "	jQuery.get('/customer/plot_precinct_cluster?precinct_id='+ ctrl.value + '', function(data) { map.openInfoWindow(center_point, \"<div id='info_window_content'>\" + data + \"You may create up to 10 different routes on this map.</div>\"); });"
			script << "}"
		end
	end
  
  def init_map_events
  	run_javascript do |script|
 			script << "function age_filter_changed() {"
			script << "	min_age = $('#walksheet_age_filter_attributes_int_val').val();"
			script << " max_age = $('#walksheet_age_filter_attributes_max_int_val').val()"
 			script << "	jQuery.get('/customer/age_filter_changed/'+min_age+'/'+max_age+'/'+'?sess_id=#{@sess_id}', function(data) { });"
 			script << "} 	"
			script << ""  
			
 			script << "function sex_filter_changed() {"
 			script << "	sex = $(this).val();"
 			script << "	jQuery.get('/customer/sex_filter_changed/'+sex+'?sess_id=#{@sess_id}', function(data) { });"
 			script << "} 	"
			script << ""  
			
 			script << "function party_filter_changed() {"
			script << "	//alert($(this).filter(':checked').val());"
			script << "	p = $(this).val();"
			script << " if ($(this).filter(':checked').length > 0) {"
			script << "		//alert('add it '+p);"
 			script << "	jQuery.get('/customer/party_filter_add/'+p+'?sess_id=#{@sess_id}', function(data) { });"
			script << "	} else {"
			script << "	  //alert('delete it '+p);"
 			script << "	jQuery.get('/customer/party_filter_remove/'+p+'?sess_id=#{@sess_id}', function(data) { });"
			script << " }"
 			script << "} 	"
			script << ""  
			 						
 			script << "function voting_history_type_filter_changed() {"
 			script << "	//alert('called');"
 			script << "	vhf = $(this).val();"
 			script << " mv = $('#walksheet_voting_history_type_filter_attributes_int_val').val();"
 			script << "	jQuery.get('/customer/voting_history_type_filter_changed/'+vhf+'/'+mv+'/'+'?sess_id=#{@sess_id}', function(data) { });"

			script << "	$('span#xval').hide();"
			script << "	if (this.value == \"At Least\") {"
			script << "		$('span#xval').css('display','inline');"
			script << "	} else if (this.value == \"Exactly\") {"
			script << "		$('span#xval').css('display','inline');"
			script << "	} else if (this.value == \"No More Than\") {"
			script << "		$('span#xval').css('display','inline');"
			script << "	}"
			script << "}"
			script << ""
			
 			script << "function voting_history_type_filter_int_val_changed() {"
 			script << "	//alert('called');"
 			script << "	vhf = $('#walksheet_voting_history_type_filter_attributes_string_val').val();"
 			script << " mv = $(this).val();"
 			script << "	jQuery.get('/customer/voting_history_type_filter_changed/'+vhf+'/'+mv+'/'+'?sess_id=#{@sess_id}', function(data) { });"
			script << "}"
			script << ""

			script << "function voting_history_filter_changed() {"
			script << "	var cb;"
			script << " var rb = '';"
			script << "	//alert(this.id);"
			script << "	$(this).children('td').each(function() {"
			script << "		$(this).children('input:checkbox').each(function() {"
			script << "			cb = $(this);"
			script << "		});"			
			script << "		$(this).children('input:radio').each(function() {"
			script << "			if ($(this).filter(':checked').length > 0) {"
			script << "				rb = $(this);"
			script << "			}"
			script << "		});"			
			script << "});"
			script << "if (cb.filter(':checked').length == 0) {"
			script << "		//alert('not checked');"
 			script << "	jQuery.get('/customer/voting_history_filter_remove/'+cb.val()+'?sess_id=#{@sess_id}', function(data) { });"
			script << "} else if (!(rb == '')) {"
			script << "	//alert(cb.val());"
 			script << "	jQuery.get('/customer/voting_history_filter_add/'+cb.val()+'/'+rb.val()+'?sess_id=#{@sess_id}', function(data) { });"
			script << "}"
			script << "}"
			script << ""
						
  	end
   end
  
  def new_init_map
    run_map_script do |mscript|

      map = Google::Map.new(:controls => [:small_map, :map_type],
														:center => {:latitude => current_political_campaign.lat, :longitude => current_political_campaign.lng},
                            :zoom => 13)
      map.enableScrollWheelZoom
			map.clear_overlays

			#clusterer = map.add_marker_clusterer	

			center_point = Eschaton::JavascriptVariable.existing(:var => :center_point) 
			center_point = Google::Location.new(:latitude => current_political_campaign.lat, :longitude => current_political_campaign.lng)
			mscript << "center_point = #{center_point}"
			#mscript << "clusterer = #{clusterer}"
			#map.pan_to center_point

			polygon = Google::Polygon.new(:vertices => [], :fill_colour => 'black', :border_colour => 'black')

			polygon.enable_drawing
			polygon.enable_editing

			map.click do |script, location|
				polygon.add_vertex(location)
			end


#			polygon.edited do |script|
#				script.post :url => { :controller => :gis_regions, :action => :add_vertices, :sess_id => "#{@sess_id}", :vertices => Google::UrlHelper.encode_vertices(polygon) }
#			end

    end
  end  
end
