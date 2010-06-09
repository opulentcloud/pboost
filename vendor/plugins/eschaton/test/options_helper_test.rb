require File.dirname(__FILE__) + '/test_helper'

class OptionsHelperTest < Test::Unit::TestCase

  def setup
    Eschaton.global_script = Eschaton.javascript_generator
  end

  def test_to_google_position
    assert_equal 'new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(0, 0))',
                 Google::OptionsHelper.to_google_position({:anchor => :top_left})
    assert_equal 'new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 50))',
                 Google::OptionsHelper.to_google_position({:anchor => :top_left, :offset => [10, 50]})
    assert_equal 'new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(10, 10))',
                 Google::OptionsHelper.to_google_position({:anchor => :top_right, :offset => [10, 10]})
  end
  
  def test_to_image
    assert_equal "/images/green.png",  Google::OptionsHelper.to_image(:green)
    assert_equal "/images/green.png", Google::OptionsHelper.to_image("/images/green.png")
  end
  
  def test_options_helper_to_icon
    assert_equal Google::Icon, Google::OptionsHelper.to_icon("green").class
    assert_equal Google::Icon, Google::OptionsHelper.to_icon(:green).class
    assert_equal Google::Icon, Google::OptionsHelper.to_icon({:image => :green}).class
  end

  def test_to_gravatar_icon
    assert_equal Google::GravatarIcon, Google::OptionsHelper.to_gravatar_icon(:email_address => 'joesoap@email.com').class    
    assert_equal Google::GravatarIcon, Google::OptionsHelper.to_gravatar_icon('joesoap@email.com').class    
  end

  def test_options_helper_to_location
    assert_equal "location", Google::OptionsHelper.to_location("location")
    assert_equal "map.getCenter()", Google::OptionsHelper.to_location("map.getCenter()")
    assert_equal :location, Google::OptionsHelper.to_location(:location)
    assert_equal :marker_location, Google::OptionsHelper.to_location(:marker_location)

    location = Google::Location.new(:latitide => 34, :longitude => 18)
    assert_equal location, Google::OptionsHelper.to_location(location)

    location_hash = {:latitide => 34, :longitude => 18}
    location = Google::OptionsHelper.to_location(location_hash)

    assert location.is_a?(Google::Location)
    assert_equal location_hash[:latitude], location.latitude
    assert_equal location_hash[:longitude], location.longitude

    location_array = [18, 34]
    location = Google::OptionsHelper.to_location(location_array)

    assert_equal Google::Location, location.class
    assert_equal location_array.first, location.latitude
    assert_equal location_array.second, location.longitude
  end
  
  def test_to_marker
    marker = Google::Marker.new(:location => {:latitude => -33.947, :longitude => 18.462})

    assert_equal marker, Google::OptionsHelper.to_marker(marker)
    assert_equal Google::Marker, Google::OptionsHelper.to_marker(:location => :existing).class    
  end

  def test_to_line
    line = Google::Line.new(:vertices => :first_location)

    assert_equal line, Google::OptionsHelper.to_line(line)
    assert_equal Google::Line, Google::OptionsHelper.to_line(:vertices => :first_location).class
  end

  def test_to_encoded_polyline
    line = {:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP', :color => 'red',
            :opacity => 0.7, :weight => 3, :num_levels => 18, :zoom_factor => 2}

    assert_equal '{color: "red", levels: "PFHFGP", numLevels: 18, opacity: 0.7, points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB", weight: 3, zoomFactor: 2}',
                  Google::OptionsHelper.to_encoded_polyline(line)
                  
    line = {:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP'}

    assert_equal '{levels: "PFHFGP", points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB"}',
                  Google::OptionsHelper.to_encoded_polyline(line)
    
    # Make sure no escaping occurs   
    line = {:points => '\a', :levels => '\a'}
    assert_equal '{levels: "\a", points: "\a"}',
                 Google::OptionsHelper.to_encoded_polyline(line)    
  end
  
  def test_to_encoded_polylines
    options = {:color => 'red', :opacity => 0.7, :weight => 3}
    options[:lines] = [{:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP', :num_levels => 18, :zoom_factor => 2},
                       {:points => 'cbglFhciuMY{FtDqBfCvD{AbFgEm@', :levels => 'PDFDEP', :num_levels => 18, :zoom_factor => 2}]

    assert_equal '[{color: "red", levels: "PFHFGP", numLevels: 18, opacity: 0.7, points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB", weight: 3, zoomFactor: 2}, {levels: "PDFDEP", numLevels: 18, points: "cbglFhciuMY{FtDqBfCvD{AbFgEm@", zoomFactor: 2}]',
                  Google::OptionsHelper.to_encoded_polylines(options)
  end
  
  def test_to_content
    assert_equal 'the mystic', Google::OptionsHelper.to_content(:text => 'the mystic')
    assert_equal '<p>the mystic</p>', Google::OptionsHelper.to_content(:html => '<p>the mystic</p>')    
    assert_equal 'test output for render', Google::OptionsHelper.to_content(:partial => 'testing')
    
    with_eschaton do |script|  
      assert_eschaton_output 'var javascript = "location is " + location;' do
                              assert_equal :javascript, Google::OptionsHelper.to_content(:javascript => '"location is " + location')      
                            end
    end
  end

  def test_to_bounds
    south_west_point_latitude, south_west_point_longitude = -34.947, 19.462
    north_east_point_latitude, north_east_point_longitude = -35.947, 20.462
        
    bounds = Google::Bounds.new(:south_west_point => [south_west_point_latitude, south_west_point_longitude], 
                                :north_east_point => [north_east_point_latitude, north_east_point_longitude])

    assert_equal bounds, Google::OptionsHelper.to_bounds(bounds)
    assert_equal south_west_point_latitude, bounds.south_west_point.latitude
    assert_equal south_west_point_longitude, bounds.south_west_point.longitude
    assert_equal north_east_point_latitude, bounds.north_east_point.latitude
    assert_equal north_east_point_longitude, bounds.north_east_point.longitude

    bounds_from_hash = Google::OptionsHelper.to_bounds(:south_west_point => [south_west_point_latitude, south_west_point_longitude], 
                                                       :north_east_point => [north_east_point_latitude, north_east_point_longitude])
    assert bounds_from_hash.is_a?(Google::Bounds)
    assert_equal south_west_point_latitude, bounds_from_hash.south_west_point.latitude
    assert_equal south_west_point_longitude, bounds_from_hash.south_west_point.longitude
    assert_equal north_east_point_latitude, bounds_from_hash.north_east_point.latitude
    assert_equal north_east_point_longitude, bounds_from_hash.north_east_point.longitude
    
    bounds_from_array = Google::OptionsHelper.to_bounds([[south_west_point_latitude, south_west_point_longitude], 
                                                         [north_east_point_latitude, north_east_point_longitude]])
    assert bounds_from_hash.is_a?(Google::Bounds)
    assert_equal south_west_point_latitude, bounds_from_array.south_west_point.latitude
    assert_equal south_west_point_longitude, bounds_from_array.south_west_point.longitude
    assert_equal north_east_point_latitude, bounds_from_array.north_east_point.latitude
    assert_equal north_east_point_longitude, bounds_from_array.north_east_point.longitude                                                      
  end
  
  def test_to_ground_overlay
    image = 'http://battlestar/images/cylon_base_star.png'
    south_west_point_latitude, south_west_point_longitude = -34.947, 19.462
    north_east_point_latitude, north_east_point_longitude = -35.947, 20.462
    
    ground_overlay = Google::GroundOverlay.new(:image => image,
                                               :south_west_point => [south_west_point_latitude, south_west_point_longitude], 
                                               :north_east_point => [north_east_point_latitude, north_east_point_longitude])
                                                             
    assert_equal ground_overlay, Google::OptionsHelper.to_ground_overlay(ground_overlay)
    
    ground_overlay_from_hash = Google::OptionsHelper.to_ground_overlay(:image => image,
                                                                       :south_west_point => [south_west_point_latitude, 
                                                                                             south_west_point_longitude], 
                                                                       :north_east_point => [north_east_point_latitude, 
                                                                                             north_east_point_longitude])
    
    assert ground_overlay_from_hash.is_a?(Google::GroundOverlay)
    assert_equal 'http://battlestar/images/cylon_base_star.png', ground_overlay_from_hash.image
    assert_equal south_west_point_latitude, ground_overlay_from_hash.bounds.south_west_point.latitude
    assert_equal south_west_point_longitude, ground_overlay_from_hash.bounds.south_west_point.longitude
    assert_equal north_east_point_latitude, ground_overlay_from_hash.bounds.north_east_point.latitude
    assert_equal north_east_point_longitude, ground_overlay_from_hash.bounds.north_east_point.longitude
  end

  def test_to_map_type
    assert_equal :G_NORMAL_MAP, Google::OptionsHelper.to_map_type(:normal)
    assert_equal :G_SATELLITE_MAP, Google::OptionsHelper.to_map_type(:satellite)
    assert_equal :G_HYBRID_MAP, Google::OptionsHelper.to_map_type(:hybrid)
    assert_equal :G_PHYSICAL_MAP, Google::OptionsHelper.to_map_type(:physical)
  end


  def test_to_google_control
    assert_equal :GSmallMapControl,  Google::OptionsHelper.to_google_control(:small_map)
    assert_equal :GScaleControl, Google::OptionsHelper.to_google_control(:scale)
    assert_equal :GMapTypeControl, Google::OptionsHelper.to_google_control(:map_type)
    assert_equal :GOverviewMapControl, Google::OptionsHelper.to_google_control(:overview_map)
    
    # 3D controls
    assert_equal :GLargeMapControl3D, Google::OptionsHelper.to_google_control(:large_map_3D)
    assert_equal :GSmallZoomControl3D, Google::OptionsHelper.to_google_control(:small_zoom_3D)
  end
    
  def test_to_google_anchor
    assert_equal :G_ANCHOR_TOP_RIGHT, Google::OptionsHelper.to_google_anchor(:top_right)
    assert_equal :G_ANCHOR_TOP_LEFT, Google::OptionsHelper.to_google_anchor(:top_left)
    assert_equal :G_ANCHOR_BOTTOM_RIGHT, Google::OptionsHelper.to_google_anchor(:bottom_right)
    assert_equal :G_ANCHOR_BOTTOM_LEFT, Google::OptionsHelper.to_google_anchor(:bottom_left)
  end

  def test_array_to_google_size
    assert_equal "new GSize(10, 10)", Google::OptionsHelper.to_google_size([10, 10])
    assert_equal "new GSize(100, 50)", Google::OptionsHelper.to_google_size([100, 50])
    assert_equal "new GSize(200, 150)", Google::OptionsHelper.to_google_size([200, 150])    
  end

end
