require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class BoundsTest < Test::Unit::TestCase

  def test_initialize
    with_eschaton do |script|      
      assert_eschaton_output "bounds = new GLatLngBounds(new GLatLng(-34.947, 19.462), new GLatLng(-35.947, 20.462));" do
                              Google::Bounds.new(:south_west_point => [-34.947, 19.462], :north_east_point => [-35.947, 20.462])
                            end
        
      assert_eschaton_output "bounds = new GLatLngBounds();" do
                              Google::Bounds.new
                            end
        
    end
  end

  def test_extend
    with_eschaton do |script|
      bounds = Google::Bounds.new

      assert_eschaton_output "bounds.extend(marker.getLatLng());" do
                              bounds.extend 'marker.getLatLng()'
                            end

      assert_eschaton_output "bounds.extend(new GLatLng(-36.947, 21.462));" do
                              bounds.extend [-36.947, 21.462]
                            end

      other_bounds = Google::Bounds.new(:south_west_point => [-34.947, 19.462], :north_east_point => [-35.947, 20.462])
                                      
      assert_eschaton_output "bounds.extend(new GLatLng(-34.947, 19.462));
                             bounds.extend(new GLatLng(-35.947, 20.462));" do
                              bounds.extend other_bounds
                            end
                            
     assert_eschaton_output "bounds.extend(marker.getLatLng());
                            bounds.extend(new GLatLng(-36.947, 21.462));
                            bounds.extend(new GLatLng(-34.947, 19.462));
                            bounds.extend(new GLatLng(-35.947, 20.462));" do
                             bounds.extend 'marker.getLatLng()', [-36.947, 21.462], other_bounds
                           end
    end
  end

end