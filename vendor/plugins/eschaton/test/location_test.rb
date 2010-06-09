require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class LocationTest < Test::Unit::TestCase

  def test_initialize
    with_eschaton do |script|

      location = Google::Location.new(:latitude => -34.947, :longitude => 19.462)
      location_output = "new GLatLng(-34.947, 19.462)"

      assert_equal location_output, location.to_s
      assert_equal location_output, location.to_js
      assert_equal location_output, location.to_json      
    end
  end

end