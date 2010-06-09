require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class LineTest < Test::Unit::TestCase

  def test_with_vertex
    with_eschaton do |script|
      assert_eschaton_output "line = new GPolyline([new GLatLng(-33.947, 18.462)], null, null, null);" do
                              Google::Line.new :vertices => {:latitude => -33.947, :longitude => 18.462}
                            end
    end    
  end

  def test_with_vertices
    with_eschaton do |script|                      
      assert_eschaton_output "line = new GPolyline([new GLatLng(-33.947, 18.462), new GLatLng(-34.0, 19.0)], null, null, null);" do
                              Google::Line.new :vertices => [{:latitude => -33.947, :longitude => 18.462},
                                                             {:latitude => -34.0, :longitude => 19.0}]
                            end
   end    
  end

  def test_with_from_and_to
    with_eschaton do |script|
      assert_eschaton_output "line = new GPolyline([new GLatLng(-33.947, 18.462), new GLatLng(-34.0, 19.0)], null, null, null);" do
                               Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                                                :to =>  {:latitude => -34.0, :longitude => 19.0}
                            end
    end
  end

  def test_with_colour
    with_eschaton do |script|
      assert_eschaton_output 'line = new GPolyline([new GLatLng(-33.947, 18.462), new GLatLng(-34.0, 19.0)], "red", null, null);' do
                              Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                                               :to =>  {:latitude => -34.0, :longitude => 19.0},
                                               :colour => 'red'
                            end
    end
  end

  def test_with_colour_and_weight
    with_eschaton do |script|    
    assert_eschaton_output 'line = new GPolyline([new GLatLng(-33.947, 18.462), new GLatLng(-34.0, 19.0)], "red", 10, null);' do
                            Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                                             :to =>  {:latitude => -34.0, :longitude => 19.0},
                                             :colour => 'red', :thickness => 10
                          end
    end
  end

  def test_with_style
    with_eschaton do |script|
      assert_eschaton_output 'line = new GPolyline([new GLatLng(-33.947, 18.462), new GLatLng(-34.0, 19.0)], "red", 10, 0.7);' do
                              Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                                               :to =>  {:latitude => -34.0, :longitude => 19.0},
                                               :colour => 'red', :thickness => 10, :opacity => 0.7
                            end
    end
  end

  def test_between_markers
    with_eschaton do |script|
      markers = [Google::Marker.new(:var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}),
                 Google::Marker.new(:var => :marker_2, :location => {:latitude => -34.0, :longitude => 19.0}),
                 Google::Marker.new(:var => :marker_3, :location => {:latitude => -35.0, :longitude => 19.0})]

      assert_eschaton_output 'line = new GPolyline([marker_1.getLatLng(), marker_2.getLatLng(), marker_3.getLatLng()], null, null, null);' do
                               Google::Line.new :between_markers => markers
                            end

      assert_eschaton_output 'line = new GPolyline([marker_1.getLatLng(), marker_2.getLatLng(), marker_3.getLatLng()], "red", 10, null);' do
                               Google::Line.new :between_markers => markers,
                                                :colour => 'red', :thickness => 10
                            end
    end
  end
  
  def test_add_vertex
    with_eschaton do |script|
      line = Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                              :to =>  {:latitude => -34.0, :longitude => 19.0}

      assert_eschaton_output 'line.insertVertex(line.getVertexCount() - 1, new GLatLng(-34.5, 19.5))' do
                              line.add_vertex :latitude => -34.5, :longitude => 19.5
                            end
    end    
  end
  
  def test_length
    with_eschaton do |script|
      line = Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                              :to =>  {:latitude => -34.0, :longitude => 19.0}

      assert_equal 'line.getLength()', line.length
      assert_equal 'line.getLength() / 1000', line.length(:kilometers)      
    end    
  end

  def test_style
    with_eschaton do |script|
      line = Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                              :to =>  {:latitude => -34.0, :longitude => 19.0}

      assert_eschaton_output 'line.setStrokeStyle({color: "red"});' do
                              line.style = {:colour => 'red'}
                            end

      assert_eschaton_output 'line.setStrokeStyle({color: "red", weight: 12});' do
                              line.style = {:colour => 'red', :thickness => 12}
                            end
                       
      assert_eschaton_output 'line.setStrokeStyle({color: "red", opacity: 0.7, weight: 12});' do
                              line.style = {:colour => 'red', :thickness => 12, :opacity => 0.7}
                            end
    end
  end

  def test_encoded
    with_eschaton do |script|
      assert_eschaton_output 'line = new GPolyline.fromEncoded({color: null, levels: "PFHFGP", numLevels: 18, opacity: null, points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB", weight: null, zoomFactor: 2});' do
                              Google::Line.new(:encoded => {:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP',
                                                            :num_levels => 18, :zoom_factor => 2})
                            end

      assert_eschaton_output 'line = new GPolyline.fromEncoded({color: "green", levels: "PFHFGP", numLevels: 18, opacity: 1, points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB", weight: 10, zoomFactor: 2});' do
                              Google::Line.new(:encoded => {:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP',
                                                            :num_levels => 18, :zoom_factor => 2},
                                               :colour => 'green', :opacity => 1, :thickness => 10)
                            end
    end
  end
    
end