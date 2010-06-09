require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class MarkerTest < Test::Unit::TestCase

  def default_marker
    Google::Marker.new(:var => :marker, :location => {:latitude => -33.947, :longitude => 18.462})
  end

  def test_initialize
    with_eschaton do |script|
      assert_eschaton_output 'marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});' do
                                marker = self.default_marker
                              end

      assert_eschaton_output 'marker = new GMarker(existing_location, {draggable: false});' do
                               marker = Google::Marker.new :var => :marker, :location => :existing_location  
                             end

      assert_eschaton_output :marker_with_icon do
                              marker = Google::Marker.new :var => :marker, :location => :existing_location, :icon => :blue
                            end

      assert_eschaton_output 'marker = new GMarker(existing_location, {draggable: false, title: "Marker title!"});' do
                              marker = Google::Marker.new :var => :marker, :location => :existing_location, :title => 'Marker title!'
                            end

      assert_eschaton_output 'marker = new GMarker(existing_location, {bouncy: false, draggable: false, title: "Marker title!"});' do
                              marker = Google::Marker.new :var => :marker, :location => :existing_location, :title => 'Marker title!',
                                                          :bouncy => false
                            end
    end
  end

  def test_initialize_with_gravatar
    with_eschaton do |script|
      assert_eschaton_output :marker_gravatar do
                               Google::Marker.new :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                                  :gravatar => 'yawningman@eschaton.com'
                             end

     assert_eschaton_output :marker_gravatar do
                              Google::Marker.new :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                                 :gravatar => {:email_address => 'yawningman@eschaton.com'}
                            end

      assert_eschaton_output :marker_gravatar_with_size do
                              Google::Marker.new :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                                 :gravatar => {:email_address => 'yawningman@eschaton.com', :size => 50}
                            end

      assert_eschaton_output :marker_gravatar_with_default_icon do
                              Google::Marker.new :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                                 :gravatar => {:email_address => 'yawningman@eschaton.com', 
                                                               :default => 'http://localhost:3000/images/blue.png'}
                            end

      assert_eschaton_output :marker_gravatar_with_size_and_default_icon do
                              Google::Marker.new :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                                  :gravatar => {:email_address => 'yawningman@eschaton.com', 
                                                                :default => 'http://localhost:3000/images/blue.png',
                                                                :size => 50}
                            end
    end 
  end

  def test_initialize_with_tooltip
    with_eschaton do |script|
      map = Google::Map.new
      assert_eschaton_output :marker_tooltip do
                               map.add_marker :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                              :tooltip => {:text => 'This is sparta!'}
                             end
                             
      assert_eschaton_output :marker_tooltip do
                              map.add_marker :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                             :tooltip => {:text => 'This is sparta!', :show => :on_mouse_hover}
                            end

      assert_eschaton_output :marker_tooltip_show_always do
                              map.add_marker :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                             :tooltip => {:text => 'This is sparta!', :show => :always}
                            end
 
      assert_eschaton_output :marker_tooltip_with_partial do
                              map.add_marker :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                             :tooltip => {:partial => 'spot_information'}
                            end
   end
  end

  def test_location
    with_eschaton do |script|
      marker = self.default_marker
      assert_equal "marker.getLatLng()", marker.location
      
      marker_one = Google::Marker.new :var => :marker_one, :location => {:latitude => -33.947, :longitude => 18.462}
      assert_equal "marker_one.getLatLng()", marker_one.location
      
      marker = Google::Marker.new :var => :marker, :location => :mouse_location
      assert_equal "marker.getLatLng()", marker.location      
   end    
  end

  def test_marker_open_info_window
    with_eschaton do |script|
      marker = self.default_marker

      assert_eschaton_output "jQuery.get('/location/show/1?location%5Blatitude%5D=' + marker.getLatLng().lat() + '&location%5Blongitude%5D=' + marker.getLatLng().lng() + '', function(data) {
                               marker.openInfoWindow(\"<div id='info_window_content'>\" + data + \"</div>\");
                             });" do
                              marker.open_info_window :url => {:controller => :location, :action => :show, :id => 1}
                            end

      assert_eschaton_output 'marker.openInfoWindow("<div id=\'info_window_content\'>" + "test output for render" + "</div>");' do
                               marker.open_info_window :partial => 'create'
                             end

      assert_eschaton_output 'marker.openInfoWindow("<div id=\'info_window_content\'>" + "Testing text!" + "</div>");' do
                               marker.open_info_window :html => "Testing text!"
                             end
                             
      assert_eschaton_output 'tabs = [];
                              tabs.push(new GInfoWindowTab("first", "First tab!"));
                              marker.openInfoWindowTabs(tabs);' do
                                marker.open_info_window :tabs => [{:label => "first", :html => "First tab!"}]
                              end                            

       assert_eschaton_output 'tabs = [];
                               tabs.push(new GInfoWindowTab("first", "First tab!"));
                               tabs.push(new GInfoWindowTab("second tab", "test output for render"));                                
                               marker.openInfoWindowTabs(tabs);' do
                                 marker.open_info_window :tabs => [{:label => "first", :html => "First tab!"},
                                                                   {:label => "second tab", :partial => 'create'}]
                               end                             
    end
  end
  
  def test_marker_cache_info_window
    with_eschaton do |script|
      marker = self.default_marker

      assert_eschaton_output "jQuery.get('/location/show/1?location%5Blatitude%5D=' + marker.getLatLng().lat() + '&location%5Blongitude%5D=' + marker.getLatLng().lng() + '', function(data) {
                               marker.bindInfoWindowHtml(\"<div id='info_window_content'>\" + data + \"</div>\");
                             });" do
                              marker.cache_info_window :url => {:controller => :location, :action => :show, :id => 1}
                            end

      assert_eschaton_output 'marker.bindInfoWindowHtml("<div id=\'info_window_content\'>" + "test output for render" + "</div>");' do
                               marker.cache_info_window :partial => 'create'
                             end

      assert_eschaton_output 'marker.bindInfoWindowHtml("<div id=\'info_window_content\'>" + "Testing text!" + "</div>");' do
                               marker.cache_info_window :html => "Testing text!"
                             end
    end
  end  

  def test_open_cached_info_window
    with_eschaton do |script|
      marker = self.default_marker

      assert_eschaton_output "GEvent.trigger(marker, 'click');" do
                               marker.open_cached_info_window
                             end
    end    
    
  end
  

  def test_click
    with_eschaton do |script|
      marker = self.default_marker

      # without body
      assert_eschaton_output :marker_click_no_body do
                                            marker.click {}
                                          end
    
      # With body
      assert_eschaton_output :marker_click_with_body do
                              marker.click do |script|
                                script.comment "This is some test code!"
                                script.alert("Hello from marker click!")
                              end
                            end

      # Info window convention
      assert_eschaton_output :marker_click_info_window do
                              marker.click :html => "This is a info window!"
                            end
    end    
  end

  def test_when_picked_up
    with_eschaton do |script|
      marker = self.default_marker
      
      assert_eschaton_output :marker_when_picked_up do
                              marker.when_picked_up{|script|
                                script.comment "This is some test code!"
                                script.alert("Hello from marker drop!")
                              }
                            end
    end
  end

  def test_when_being_dragged
    with_eschaton do |script|
      marker = self.default_marker
      
      assert_eschaton_output :marker_when_being_dragged do
                              marker.when_being_dragged{|script, current_location|
                                script.comment "This is some test code!"
                                script.alert("Hello from marker drag!")
                              }
                            end
    end
  end
  
  def test_when_dropped
    with_eschaton do |script|
      marker = self.default_marker
    
      assert_eschaton_output :marker_when_dropped do
        marker.when_dropped do |script, drop_location|
          assert_equal :drop_location, drop_location
          
          script.comment "This is some test code!"
          script.alert("Hello from marker drop!")
        end
      end
    end
  end
  
  def test_show_map_blowup
    with_eschaton do |script|
      marker = self.default_marker
      
      # Default with hash location
      assert_eschaton_output 'marker.showMapBlowup({});' do
                              marker.show_map_blowup
                            end
      
      # With :zoom_level
      assert_eschaton_output 'marker.showMapBlowup({zoomLevel: 12});' do
                              marker.show_map_blowup :zoom_level => 12
                            end

      # With :marker_type
      assert_eschaton_output 'marker.showMapBlowup({mapType: G_SATELLITE_MAP});' do
                              marker.show_map_blowup :map_type => :satellite
                            end

      # With :zoom_level and :marker_type
      assert_eschaton_output 'marker.showMapBlowup({mapType: G_SATELLITE_MAP, zoomLevel: 12});' do
                              marker.show_map_blowup :zoom_level => 12, :map_type => :satellite
                            end
    end
  end
  
  def test_change_icon
    with_eschaton do |script|
      marker = self.default_marker
      
      assert_eschaton_output 'marker.setImage("/images/green.png");' do
                               marker.change_icon :green
                             end

      assert_eschaton_output 'marker.setImage("/images/blue.png");' do
                              marker.change_icon "/images/blue.png"
                            end
    end
  end
  
  def test_circle
    with_eschaton do |script|
      assert_eschaton_output 'marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                             circle_marker = drawCircle(marker.getLatLng(), 1.5, 40, null, 2, null, "#0055ff", null);' do
                               Google::Marker.new :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                                  :circle => true
                             end
 
      assert_eschaton_output 'marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                             circle_marker = drawCircle(marker.getLatLng(), 500, 40, null, 5, null, "#0055ff", null);' do
                              Google::Marker.new :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                                 :circle => {:radius => 500, :border_width => 5}
                            end

     marker = self.default_marker

     assert_eschaton_output 'circle_marker = drawCircle(marker.getLatLng(), 1.5, 40, null, 2, null, "#0055ff", null);' do
                              marker.circle!  
                            end

     assert_eschaton_output 'circle_marker = drawCircle(marker.getLatLng(), 500, 40, null, 5, null, "#0055ff", null);' do
                             marker.circle! :radius => 500, :border_width => 5
                           end

     assert_eschaton_output 'circle_marker = drawCircle(marker.getLatLng(), 500, 40, null, 5, null, "black", null);' do
                             marker.circle! :radius => 500, :border_width => 5, :fill_colour => 'black'
                           end
    end    
  end
  
  # TODO - Figure this on out!
  def xtest_set_tooltip
    with_eschaton do |script|            
      marker = self.default_marker
      
      assert_eschaton_output :marker_set_tooltip_default do
                               marker.set_tooltip :text => 'This is sparta!'
                             end

      assert_eschaton_output :marker_set_tooltip_default do
                              marker.set_tooltip :text => 'This is sparta!', :show => :on_mouse_hover
                            end
                            
      assert_eschaton_output :marker_set_tooltip_show_always do
                              marker.set_tooltip :text => 'This is sparta!', :show => :always
                            end

      assert_eschaton_output :marker_set_tooltip_show_false do
                              marker.set_tooltip :text => 'This is sparta!', :show => false
                            end
      
      assert_eschaton_output :marker_set_tooltip_default_with_partial do
                              marker.set_tooltip :partial => 'spot_information'
                            end

     assert_eschaton_output :marker_set_tooltip_default_with_partial do
                             marker.set_tooltip :partial => 'spot_information', :show => :on_mouse_hover
                           end
                           
      assert marker.has_tooltip?                                          
    end
  end

  def test_update_tooltip
    with_eschaton do |script|            
      map = Google::Map.new
      marker = map.add_marker :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                              :tooltip => {:text => 'tooltip'}
      
      # If you update and there is no tooltip it will use the default behavior
      assert_eschaton_output :marker_set_tooltip_default do
                              marker.update_tooltip :text => 'This is sparta!'
                            end

      assert_eschaton_output 'tooltip_marker.updateHtml("This is sparta!");' do
                              marker.update_tooltip :text => 'This is sparta!'
                            end

      assert_eschaton_output 'tooltip_marker.updateHtml("test output for render");' do
                               marker.update_tooltip :partial => 'This is sparta!'
                             end

      assert marker.has_tooltip?
    end
  end

  def test_show_tooltip
    with_eschaton do |script|            
      marker = Google::Marker.new :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                  :tooltip => {:text => 'This is sparta!'}

      assert_eschaton_output 'tooltip_marker.show();' do
                               marker.tooltip.show!
                             end
    end    
  end

  def test_hide_tooltip
    with_eschaton do |script|            
      marker = Google::Marker.new :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462},
                                  :tooltip => {:text => 'This is sparta!'}

      assert_eschaton_output 'tooltip_marker.hide();' do
                               marker.tooltip.hide!
                             end
    end    
  end

  def test_draggable
    with_eschaton do |script|
      assert_eschaton_output 'marker = new GMarker(existing_location, {draggable: false});' do
                              marker = Google::Marker.new :var => :marker, :location => :existing_location
                              assert_false marker.draggable?
                            end

      assert_eschaton_output :marker_draggable do
                              marker = Google::Marker.new :var => :marker, :location => :existing_location, :title => 'Draggable marker!', 
                                                          :draggable => true
                              assert marker.draggable?
                            end
    end    
  end

  def test_mouse_over
    with_eschaton do |script|
      marker = self.default_marker
      
      assert_eschaton_output :marker_mouse_over do
                              marker.mouse_over{|script|
                                script.comment "This is some test code!"
                                script.alert("Hello from marker drop!")
                              }
                            end
    end
  end

  def test_mouse_off
    with_eschaton do |script|
      marker = self.default_marker
      
      assert_eschaton_output :marker_mouse_off do
                              marker.mouse_off{|script|
                                script.comment "This is some test code!"
                                script.alert("Hello from marker drop!")
                              }
                            end
    end
  end

  def test_move_to
    with_eschaton do |script|            
      marker = self.default_marker
      assert_eschaton_output 'marker.setLatLng(new GLatLng(-33.947, 18.562));' do
                               marker.move_to :latitude => -33.947, :longitude => 18.562
                             end
                             
      marker.set_tooltip :text => "This is sparta!"

      assert_eschaton_output 'marker.setLatLng(new GLatLng(-33.947, 18.562));
                             tooltip_marker.redraw(true);' do
                              marker.move_to :latitude => -33.947, :longitude => 18.562
                            end
       
      marker.circle! 
                            
      assert_eschaton_output 'marker.setLatLng(new GLatLng(-33.947, 18.562));
                             tooltip_marker.redraw(true);
                             map.removeOverlay(circle_marker)
                             circle_marker = drawCircle(new GLatLng(-33.947, 18.562), 1.5, 40, null, 2, null, "#0055ff", null);' do
                              marker.move_to :latitude => -33.947, :longitude => 18.562
                            end
    end    
  end
  
  def test_after_info_window_opened
    with_eschaton do |script|
      marker = self.default_marker
  
      assert_eschaton_output 'function marker_infowindowopen(marker){
                               return GEvent.addListener(marker, "infowindowopen", function() {
                                 alert("Info window opened on marker!");
                               });
                             }
                             marker_infowindowopen_event = marker_infowindowopen(marker);' do
                              marker.after_info_window_opened do |script|
                                script.alert('Info window opened on marker!')
                              end
                            end
    end
  end  
  
end