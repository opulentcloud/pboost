require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)
    
class GoogleGeneratorExtTest < Test::Unit::TestCase

  def test_global_map_var    
    with_eschaton do |script|

      script.google_map_script do
        map = Google::Map.new :center => :cape_town, :zoom => 9
      end

      assert_eschaton_output "var map;
                             jQuery(document).ready(function() {
                             window.onunload = GUnload;
                             if (GBrowserIsCompatible()) {
                             track_bounds = new GLatLngBounds();                               
                             map_lines = new Array();
                             map = new GMap2(document.getElementById('map'));
                             map.setCenter(cape_town);
                             map.setZoom(9);
                             last_mouse_location = map.getCenter();
                             function map_mousemove(map){
                             return GEvent.addListener(map, \"mousemove\", function(location) {
                             last_mouse_location = location;
                             });
                             }
                             map_mousemove_event = map_mousemove(map);
                             map.addControl(new GLargeMapControl3D());
                             map.addControl(new GMapTypeControl());                             
                             } else { alert('Your browser be old, it cannot run google maps!');}
                             })", script
    end
  end
  
  def test_mapping_scripts
    generator = Eschaton.javascript_generator

    generator.google_map_script do

      Google::Scripts.before_map_script do |script|
        script.comment "Before 1"
        script.comment "Before 2"
      end

      Google::Scripts.after_map_script do |script|
        script.comment "After 1"
        script.comment "After 2"
      end

      generator.comment "Map script"
    end

    assert_eschaton_output "/* Before 1 */
                           /* Before 2 */
                           jQuery(document).ready(function() {
                           window.onunload = GUnload;
                           if (GBrowserIsCompatible()) {
                           /* Map script */
                           } else { alert('Your browser be old, it cannot run google maps!');}
                           })
                           /* After 1 */
                           /* After 2 */",
                          generator
  end  
  
  
  def test_google_map_script
    with_eschaton do |script|
      
      assert_eschaton_output :google_map_script_no_body do
                              script.google_map_script {}
                            end

      assert_eschaton_output :google_map_script_with_body do
                              script.google_map_script do
                                script.comment "This is some test code!"
                                script.alert("Hello!")
                              end
                            end
    end
  end
  
  def test_set_coordinate_elements
    with_eschaton do |script|
      
      assert_eschaton_output "$('latitude').value = location.lat();
                             $('longitude').value = location.lng();" do
                              script.set_coordinate_elements :location => :location
                            end
      
      map = Google::Map.new :center => {:latitude => -35.0, :longitude => 19.0}
      
      # Testing with map center    
      assert_eschaton_output "$('latitude').value = map.getCenter().lat();
                             $('longitude').value = map.getCenter().lng();" do
                              script.set_coordinate_elements :location => map.center
                            end

      marker = map.add_marker(:var => :marker, :location => map.center)
      
      # Testing with a marker location
      assert_eschaton_output "$('latitude').value = marker.getLatLng().lat();
                             $('longitude').value = marker.getLatLng().lng();" do
                              script.set_coordinate_elements :location => marker.location
                            end

      # With specific element names
      assert_eschaton_output "$('location_latitude').value = location.lat();
                             $('location_longitude').value = location.lng();" do
                              script.set_coordinate_elements :location => :location,
                                                             :latitude_element => :location_latitude,
                                                             :longitude_element => :location_longitude
                            end
    end    

  end

end
