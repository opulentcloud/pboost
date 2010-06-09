require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class MarkerClustererTest < Test::Unit::TestCase
  
  def setup
    Google::Scripts.clear_events!
  end
  
  def test_new
    with_eschaton do |script|
      map = Google::Map.new

      assert_eschaton_output 'var cluster_markers = new Array();
                              marker_1 = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              cluster_markers.push(marker_1);
                              marker_2 = new GMarker(new GLatLng(-33.979, 18.465), {draggable: false});
                              cluster_markers.push(marker_2);
                              marker_3 = new GMarker(new GLatLng(-33.999, 18.469), {draggable: false});
                              cluster_markers.push(marker_3);' do
                              clusterer = map.add_marker_clusterer :var => :cluster

                              clusterer.add_marker :var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}
                              clusterer.add_marker :var => :marker_2, :location => {:latitude => -33.979, :longitude => 18.465}
                              clusterer.add_marker :var => :marker_3, :location => {:latitude => -33.999, :longitude => 18.469}      
      end
      
      assert_eschaton_output 'if(!track_bounds.isEmpty()){
                              map.setCenter(track_bounds.getCenter());
                              }
                              map.setZoom(map.getBoundsZoomLevel(track_bounds));
                              cluster = new MarkerClusterer(map, cluster_markers, {});', Google::Scripts.end_of_map_script.to_s

      
    end
  end

  def test_new_with_options
    with_eschaton do |script|
      map = Google::Map.new

      assert_eschaton_output 'var cluster_markers = new Array();
                              marker_1 = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              cluster_markers.push(marker_1);' do
                              clusterer = map.add_marker_clusterer :var => :cluster, 
                                                                      :grid_size => 80,
                                                                      :max_zoom => 12

                              clusterer.add_marker :var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}
      end
      
      
      assert_eschaton_output 'if(!track_bounds.isEmpty()){
                              map.setCenter(track_bounds.getCenter());
                              }
                              map.setZoom(map.getBoundsZoomLevel(track_bounds));
                              cluster = new MarkerClusterer(map, cluster_markers, {gridSize: 80, maxZoom: 12});', Google::Scripts.end_of_map_script.to_s      
      
    end
  end

  def test_new_with_styles
    with_eschaton do |script|
      map = Google::Map.new

      assert_eschaton_output 'var cluster_markers = new Array();
                              marker_1 = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              cluster_markers.push(marker_1);' do
                              clusterer = map.add_marker_clusterer :var => :cluster, 
                                                                      :styles => [{:height => 10, :url => 'small.png'}, 
                                                                                  {:height => 20, :url => 'bigger.png', :text_colour => :blue}]

                              clusterer.add_marker :var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}
      end
      
      assert_eschaton_output 'if(!track_bounds.isEmpty()){
                              map.setCenter(track_bounds.getCenter());
                              }
                              map.setZoom(map.getBoundsZoomLevel(track_bounds));
                              cluster = new MarkerClusterer(map, cluster_markers, {styles: [{height: 10, url: "small.png"},{height: 20, opt_textColor: blue, url: "bigger.png"}]});', Google::Scripts.end_of_map_script.to_s      
      
    end
  end

  def test_style_option_renaming
    with_eschaton do |script|
      map = Google::Map.new

      assert_eschaton_output 'var cluster_markers = new Array();
                              marker_1 = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                              cluster_markers.push(marker_1);' do
                              clusterer = map.add_marker_clusterer :var => :cluster, 
                                                                      :styles => [{:text_colour => 10, :anchor => [1, 2]}]

                              clusterer.add_marker :var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}
      end
      
      assert_eschaton_output 'if(!track_bounds.isEmpty()){
                              map.setCenter(track_bounds.getCenter());
                              }
                              map.setZoom(map.getBoundsZoomLevel(track_bounds));
                              cluster = new MarkerClusterer(map, cluster_markers, {styles: [{opt_anchor: [1, 2], opt_textColor: 10}]});', Google::Scripts.end_of_map_script.to_s      
      
    end
  end

end