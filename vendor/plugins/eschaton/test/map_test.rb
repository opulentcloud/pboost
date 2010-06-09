require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)
    
class MapTest < Test::Unit::TestCase
  
  def default_test_map
    Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
  end
  
  def test_map_initialize
    assert_eschaton_output :map_default,
                          Eschaton.with_global_script{ 
                            map = Google::Map.new
                          }

    assert_eschaton_output :map_with_center, 
                          Eschaton.with_global_script{
                            map = Google::Map.new :center => {:latitude => -35.0, :longitude => 19.0}
                          }
    
    assert_eschaton_output :map_with_args,
                          Eschaton.with_global_script{
                            map = Google::Map.new :center => {:latitude => -35.0, :longitude => 19.0},
                                                  :controls => [:small_map, :map_type],
                                                  :zoom => 12,
                                                  :type => :satellite
                          }
  end

  def test_add_control
    with_eschaton do |script|
      script.google_map_script do
        map = self.default_test_map

        assert_eschaton_output 'map.addControl(new GSmallMapControl());' do
                                 map.add_control :small_map
                               end

        assert_eschaton_output 'map.addControl(new GSmallMapControl(), new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(0, 0)));' do
                                map.add_control :small_map, :position => {:anchor => :top_right}
                              end

        assert_eschaton_output 'map.addControl(new GSmallMapControl(), new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(50, 10)));' do
                                map.add_control :small_map, :position => {:anchor => :top_right, :offset => [50, 10]}
                              end

        assert_eschaton_output 'map.addControl(new GSmallMapControl());' do
                                 map.controls = :small_map
                               end

        assert_eschaton_output :map_controls do
                                 map.controls = :small_map, :map_type
                               end
        # 3D controls                       
        assert_eschaton_output 'map.addControl(new GLargeMapControl3D());' do
                                 map.add_control :large_map_3D
                               end

        assert_eschaton_output 'map.addControl(new GSmallZoomControl3D());' do
                                 map.add_control :small_zoom_3D
                              end
      end
    end
  end

  def test_open_info_window_output
    with_eschaton do |script|
      script.google_map_script do
        map = self.default_test_map
      
        # With :url and :include_location params
        assert_eschaton_output :map_open_info_window_url_center do
                                map.open_info_window :url => {:controller => :location, :action => :create}
                              end

        assert_eschaton_output :map_open_info_window_url_center do
                                map.open_info_window :location => :center, 
                                                     :url => {:controller => :location, :action => :create}
                              end


        assert_eschaton_output :map_open_info_window_url_existing_location do
                                map.open_info_window :location => :existing_location, 
                                                     :url => {:controller => :location, :action => :create}
                              end

        assert_eschaton_output :map_open_info_window_url_location do
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, 
                                                     :url => {:controller => :location, :action => :create}
                              end

        assert_eschaton_output :map_open_info_window_url_no_location do
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, 
                                                     :url => {:controller => :location, :action => :show, :id => 1},
                                                     :include_location => false
                              end

        assert_eschaton_output 'map.openInfoWindow(new GLatLng(-33.947, 18.462), "<div id=\'info_window_content\'>" + "test output for render" + "</div>");' do
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, :partial => 'create'
                              end

        assert_eschaton_output 'map.openInfoWindow(new GLatLng(-33.947, 18.462), "<div id=\'info_window_content\'>" + "Testing text!" + "</div>");' do
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, :html => "Testing text!"
                              end
                              
        assert_eschaton_output 'tabs = [];
                                tabs.push(new GInfoWindowTab("first", "First tab!"));
                                map.openInfoWindowTabs(new GLatLng(-33.947, 18.462), tabs);' do
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, 
                                                     :tabs => [{:label => "first", :html => "First tab!"}]
                              end                            
                              
        assert_eschaton_output 'tabs = [];
                                tabs.push(new GInfoWindowTab("first", "First tab!"));
                                tabs.push(new GInfoWindowTab("second tab", "test output for render"));                                
                                map.openInfoWindowTabs(new GLatLng(-33.947, 18.462), tabs);' do
                                map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, 
                                                     :tabs => [{:label => "first", :html => "First tab!"},
                                                               {:label => "second tab", :partial => 'create'}]
                              end                             
                              
                              
                              
      end
    end    
  end
  
  def test_update_info_window
    with_eschaton do |script|
      script.google_map_script do      
        map = self.default_test_map    
      
        assert_eschaton_output 'map.openInfoWindow(map.getInfoWindow().getPoint(), "<div id=\'info_window_content\'>" + "Testing text!" + "</div>");' do
                                 map.update_info_window :html => "Testing text!"
                               end
      end
    end
  end
  
  def test_click_output
    with_eschaton do |script|
      script.google_map_script do
        map = self.default_test_map 

        # without body
        assert_eschaton_output :map_click_no_body do
                                map.click {}
                              end
    
        # With body
        assert_eschaton_output :map_click_with_body do
                                map.click do |script, location|
                                  script.comment "This is some test code!"
                                  script.comment "'#{location}' is where the map was clicked!"
                                  script.alert("Hello from map click!")
                                end
                              end

        # Info window convenience
        assert_eschaton_output :map_click_info_window do
                                map.click :html => "This is a info window!"
                              end
      end
    end    
  end

  def test_add_marker_manager
    with_eschaton do |script|
      script.google_map_script do
        map = self.default_test_map
      
        assert_eschaton_output 'manager = new MarkerManager(map, {});' do
                                map.add_marker_manager :var => :manager
                              end
                              
        assert_eschaton_output 'manager = new MarkerManager(map, {borderPadding: 100, maxZoom: 22});' do
                                map.add_marker_manager :var => :manager, :border_padding => 100, :maximum_zoom => 22
                              end                              
      end
    end    
  end

  def test_add_marker_output
    with_eschaton do |script|
      script.google_map_script do
        map = self.default_test_map
      
        assert_eschaton_output "marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                               map.addOverlay(marker);
                               track_bounds.extend(marker.getLatLng());" do
                                map.add_marker :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462}
                              end

        assert_eschaton_output "marker_1 = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              map.addOverlay(marker_1);
                              track_bounds.extend(marker_1.getLatLng());
                              marker_2 = new GMarker(new GLatLng(-34.947, 19.462), {draggable: false});
                              map.addOverlay(marker_2);
                              track_bounds.extend(marker_2.getLatLng());" do
                                map.add_markers({:var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}},
                                                {:var => :marker_2, :location => {:latitude => -34.947, :longitude => 19.462}})
                              end
      end
    end
  end

  def test_replace_marker_output
    with_eschaton do |script|
      map = self.default_test_map

      assert_eschaton_output "map.removeOverlay(marker);
                             marker.closeInfoWindow();
                             if(typeof(tooltip_marker) != 'undefined'){
                             map.removeOverlay(tooltip_marker);
                             }
                             if(typeof(circle_marker) != 'undefined'){
                             map.removeOverlay(circle_marker);
                             }                            
                             marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                             map.addOverlay(marker);
                             track_bounds.extend(marker.getLatLng());" do
                              map.replace_marker :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462}
                            end
    end
  end

  def test_change_marker_output
    with_eschaton do |script|
      map = self.default_test_map

      assert_eschaton_output "map.removeOverlay(create_spot);
                             create_spot.closeInfoWindow();
                             if(typeof(tooltip_create_spot) != 'undefined'){
                             map.removeOverlay(tooltip_create_spot);
                             }
                             if(typeof(circle_create_spot) != 'undefined'){
                             map.removeOverlay(circle_create_spot);
                             }
                             marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                             map.addOverlay(marker);
                             track_bounds.extend(marker.getLatLng());" do
                              map.change_marker :create_spot,
                                                {:var => :marker,
                                                 :location => {:latitude => -33.947, :longitude => 18.462}}
                            end
    end
  end

  def test_add_line
    with_eschaton do |script|
      map = self.default_test_map
      line = map.add_line :vertices => {:latitude => -33.947, :longitude => 18.462}
      
      assert line.is_a?(Google::Line)
    end
  end


  def test_add_circle
    with_eschaton do |script|
      map = self.default_test_map
      circle = map.add_circle :location => {:latitude => -33.947, :longitude => 18.462}

      assert circle.is_a?(Google::Circle)
    end
  end


  def test_add_circle_output
    with_eschaton do |script|
      map = self.default_test_map

      add_circle_output = 'circle = drawCircle(new GLatLng(-33.947, 18.462), 1.5, 40, null, 2, null, "#0055ff", null);
                           map.addOverlay(circle);'
                           
      assert_eschaton_output add_circle_output do
                              map.add_circle Google::Circle.new(:location => {:latitude => -33.947, :longitude => 18.462})
                            end
      
      assert_eschaton_output add_circle_output do
                              map.add_circle :location => {:latitude => -33.947, :longitude => 18.462}
                            end
    end
  end


  def test_add_line_output
    with_eschaton do |script|
      map = self.default_test_map
      
      assert_eschaton_output :map_add_line_with_vertex do
                              line = map.add_line :vertices => {:latitude => -33.947, :longitude => 18.462}
                            end
                            
      assert_eschaton_output :map_add_line_with_vertices do
                              map.add_line :vertices => [{:latitude => -33.947, :longitude => 18.462},
                                                         {:latitude => -34.0, :longitude => 19.0}]
                            end

      assert_eschaton_output :map_add_line_with_from_and_to do
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0}
                            end

      assert_eschaton_output :map_add_line_with_colour do
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0},
                                           :colour => 'red'
                            end

      assert_eschaton_output :map_add_line_with_colour_and_thickness do
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0},
                                           :colour => 'red', :thickness => 10
                            end

      assert_eschaton_output :map_add_line_with_style do
                              map.add_line :from => {:latitude => -33.947, :longitude => 18.462},
                                           :to =>  {:latitude => -34.0, :longitude => 19.0},
                                           :colour => 'red', :thickness => 10, :opacity => 0.7
                            end

      markers = [Google::Marker.new(:var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}),
                 Google::Marker.new(:var => :marker_2, :location => {:latitude => -34.0, :longitude => 19.0}),
                 Google::Marker.new(:var => :marker_3, :location => {:latitude => -35.0, :longitude => 19.0})]

      assert_eschaton_output :map_add_line_between_markers do
                              map.add_line :between_markers => markers
                            end

      assert_eschaton_output :map_add_line_between_markers_with_style do
                              map.add_line :between_markers => markers,
                                           :colour => 'red', :weigth => 10, :opacity => 0.7
                            end
    end
  end

  def test_clear_output
    with_eschaton do |script|
      map = self.default_test_map
      
      assert_eschaton_output 'map.clearOverlays();' do
                              map.clear
                            end
    end
  end

  def test_show_map_blowup_output
    with_eschaton do |script|
      map = self.default_test_map
      
      # Default with hash location
      assert_eschaton_output 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {});' do
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462}
                            end

     # Default with existing_location
     assert_eschaton_output 'map.showMapBlowup(existing_location, {});' do
                     map.show_blowup :location => :existing_location
                   end
      
      # With :zoom_level
      assert_eschaton_output 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {zoomLevel: 12});' do
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                              :zoom_level => 12
                            end

      # With :map_type
      assert_eschaton_output 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {mapType: G_SATELLITE_MAP});' do
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                              :map_type => :satellite
                            end

      # With :zoom_level and :map_type
      assert_eschaton_output 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {mapType: G_SATELLITE_MAP, zoomLevel: 12});' do
                              map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                              :zoom_level => 12,
                                              :map_type => :satellite
                            end
    end
  end

  def test_remove_type
    with_eschaton do |script|
      map = self.default_test_map
      
      assert_eschaton_output 'map.removeMapType(G_SATELLITE_MAP);' do
                              map.remove_type :satellite
                            end

      assert_eschaton_output :map_remove_type do
                              map.remove_type :normal, :satellite
                            end
   end
  end
  
  def test_best_fit_center
    Google::Scripts.clear_events!

    with_eschaton do |script|
      script.google_map_script do
        map = Google::Map.new :center => :best_fit

        map.add_marker :var => :marker, :location => {:latitude => -33.0, :longitude => 18.0}
        map.add_marker :var => :marker, :location => {:latitude => -33.5, :longitude => 18.5}      
      end
      
      assert_eschaton_output :map_best_fit_center, script      
    end
  end

  def test_best_fit_center_and_zoom
    Google::Scripts.clear_events!
        
    with_eschaton do |script|
      script.google_map_script do
        map = Google::Map.new :center => :best_fit, :zoom => :best_fit

        map.add_marker :var => :marker, :location => {:latitude => -33.0, :longitude => 18.0}
        map.add_marker :var => :marker, :location => {:latitude => -33.5, :longitude => 18.5}
      end

      assert_eschaton_output :map_best_fit_center_and_zoom, script
    end
  end

  def test_auto_zoom
    with_eschaton do |script|
      map = self.default_test_map
            
      assert_eschaton_output 'map.setZoom(map.getBoundsZoomLevel(track_bounds));' do
                              map.auto_zoom!
                            end
    end
  end

  def test_auto_center
    with_eschaton do |script|
      map = self.default_test_map
            
      assert_eschaton_output 'if(!track_bounds.isEmpty()){
                               map.setCenter(track_bounds.getCenter());
                            }' do
                              map.auto_center!
                            end  
    end
  end

  def test_auto_fit
    with_eschaton do |script|
      map = self.default_test_map
            
      assert_eschaton_output 'map.setZoom(map.getBoundsZoomLevel(track_bounds));
                             if(!track_bounds.isEmpty()){
                               map.setCenter(track_bounds.getCenter());
                             }' do
                              map.auto_fit!
                            end 
    end
  end

  def test_add_ground_overlay
    with_eschaton do |script|
      map = self.default_test_map
      output = "bounds = new GLatLngBounds(new GLatLng(-33.947, 18.462), new GLatLng(-34.947, 19.462));
                ground_overlay = new GGroundOverlay('http://battlestar/images/cylon_base_star.png', bounds);
                map.addOverlay(ground_overlay);
                track_bounds.extend(new GLatLng(-33.947, 18.462));
                track_bounds.extend(new GLatLng(-34.947, 19.462));"
      
      ground_overlay_options = {:image => "http://battlestar/images/cylon_base_star.png",
                                :south_west_point => [-33.947, 18.462],
                                :north_east_point => [-34.947, 19.462]}

      # TODO - This is a hack, see Github issue http://github.com/yawningman/eschaton/issues/#issue/1
      ground_overlay_other = ground_overlay_options.clone

      assert_eschaton_output output do
                              map.add_ground_overlay ground_overlay_options
                            end

      assert_eschaton_output output do
                              map.add_ground_overlay Google::GroundOverlay.new(ground_overlay_other)
                            end
                            
    end    
  end
  
  def test_after_info_window_opened
    with_eschaton do |script|
      map = self.default_test_map
  
      assert_eschaton_output 'function map_infowindowopen(map){
                               return GEvent.addListener(map, "infowindowopen", function() {
                                 alert("Info window opened on map!");
                               });
                             }
                             map_infowindowopen_event = map_infowindowopen(map);' do
                              map.after_info_window_opened do |script|
                                script.alert('Info window opened on map!')
                              end
                            end
    end
  end

end
