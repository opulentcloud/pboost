require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class UrlHelperTest < Test::Unit::TestCase
  
  def setup
    @encoded_polygon_vertices = "[-33.91,18.48],[-33.93,18.44]"
    @decoded_polygon_vertices = [{:latitude=>"-33.91", :longitude=>"18.48"}, 
                                 {:latitude=>"-33.93", :longitude=>"18.44"}]
  end

  def test_encode
    with_eschaton do |script|
      polygon = Google::Polygon.new :var => :the_polygon, :vertices => @decoded_polygon_vertices

      assert_equal '#location', Google::UrlHelper.encode(:location)
      assert_equal '#the_polygon', Google::UrlHelper.encode(polygon)
      assert_equal '#1 + 1', Google::UrlHelper.encode('1 + 1')
    end    
  end

  def test_encode_polygon
    with_eschaton do |script|
      polygon = Google::Polygon.new :vertices => @decoded_polygon_vertices

      assert_eschaton_output "var url_vertices = '';
                             for(var i = 0; i < polygon.getVertexCount(); i++){
                             url_vertices += '[' + polygon.getVertex(i).toUrlValue() + '],';
                             }
                             url_vertices = url_vertices.substring(0, url_vertices.length - 1);" do
                               assert_equal '#url_vertices', Google::UrlHelper.encode_vertices(polygon)
                             end
    end
  end
  
  def test_decode_polygon
    assert_equal @decoded_polygon_vertices,
                 Google::UrlHelper.decode_vertices(@encoded_polygon_vertices)
  end
  
  def test_encode_location
    google_location = Google::Location.new(:latitude=>"-33.91", :longitude=>"18.48")

    assert_equal ({:latitude => "-33.91", :longitude=> "18.48"}),
                 Google::UrlHelper.encode_location(google_location)

    assert_equal ({:latitude => "#drop_location.lat()", :longitude => "#drop_location.lng()"}),
                 Google::UrlHelper.encode_location(:drop_location)

    assert_equal ({:latitude => "#map.getCenter().lat()", :longitude => "#map.getCenter().lng()"}),
                 Google::UrlHelper.encode_location('map.getCenter()')
  end
    
end