require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class MarkerManagerTest < Test::Unit::TestCase

  def test_new
    with_eschaton do |script|
      map = Google::Map.new
      
      assert_eschaton_output 'manager = new MarkerManager(map, {});' do
        Google::MarkerManager.new(:var => :manager)
      end

      assert_eschaton_output 'manager = new MarkerManager(map, {borderPadding: 100, maxZoom: 15, trackMarkers: true});' do
        Google::MarkerManager.new(:var => :manager, 
                                  :border_padding => 100, 
                                  :maximum_zoom => 15, 
                                  :track_markers => true)
      end
      
    end
  end
  
  def test_add_marker
    with_eschaton do |script|            
      map = Google::Map.new
      manager = Google::MarkerManager.new(:var => :manager)
      
      # Marker options with no other options        
      assert_eschaton_output 'marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              manager.addMarker(marker, 1)' do
        manager.add_marker :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462}
      end
      
      # Marker object with no other options        
      marker = map.add_marker :var => :marker, :location => {:latitude => -33.947, :longitude => 18.462}

      assert_eschaton_output 'manager.addMarker(marker, 1)' do
        manager.add_marker marker
      end

      # With options and defaults
      assert_eschaton_output 'marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              manager.addMarker(marker, 1)' do
        manager.add_marker :marker => {:var => :marker, :location => {:latitude => -33.947, :longitude => 18.462}}
      end
      
      assert_eschaton_output 'marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              manager.addMarker(marker, 12)' do
        manager.add_marker :marker => {:var => :marker, :location => {:latitude => -33.947, :longitude => 18.462}},
                           :minimum_zoom => 12
      end
                           
      assert_eschaton_output 'marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              manager.addMarker(marker, 1, 22)' do
        manager.add_marker :marker => {:var => :marker, :location => {:latitude => -33.947, :longitude => 18.462}},
                           :maximum_zoom => 22
      end
      
      assert_eschaton_output 'marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              manager.addMarker(marker, 12, 22)' do
        manager.add_marker :marker => {:var => :marker, :location => {:latitude => -33.947, :longitude => 18.462}},
                           :minimum_zoom => 12,
                           :maximum_zoom => 22
      end
    end    
  end
  
  def test_add_markers
    with_eschaton do |script|
      map = Google::Map.new
      manager = Google::MarkerManager.new(:var => :manager)
      
      assert_eschaton_output 'marker_1 = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              manager.addMarker(marker_1, 1)
                              marker_2 = new GMarker(new GLatLng(-33.947, 18.562), {draggable: false});
                              manager.addMarker(marker_2, 1)' do
        manager.add_markers [{:var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}},
                             {:var => :marker_2, :location => {:latitude => -33.947, :longitude => 18.562}}]
      end
      
      
      marker_1 = map.add_marker :var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}
      marker_2 = map.add_marker :var => :marker_2, :location => {:latitude => -33.947, :longitude => 18.562 }       
      
      assert_eschaton_output 'manager.addMarker(marker_1, 15)
                              manager.addMarker(marker_2, 16)' do
        manager.add_markers [{:marker => marker_1, :minimum_zoom => 15}, 
                             {:marker => marker_2, :minimum_zoom => 16}]
      end      
      
    end
  end

end