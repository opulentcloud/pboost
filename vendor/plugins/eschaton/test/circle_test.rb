require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class CircleTest < Test::Unit::TestCase

  def test_initialize
    with_eschaton do |script|
      location = {:latitude => -35.0, :longitude => 18.0}

      assert_eschaton_output 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1.5, 40, null, 2, null, "#0055ff", null);' do
                               Google::Circle.new :location => location
                             end

      assert_eschaton_output 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, null, 2, null, "#0055ff", null);' do
                              Google::Circle.new :location => location, :radius => 1000
                            end

      assert_eschaton_output 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, "red", 2, null, "#0055ff", null);' do
                              Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red'
                            end

      assert_eschaton_output 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, "red", 5, null, "#0055ff", null);' do
                             Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
                                                :border_width => 5
                            end

      assert_eschaton_output 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, "red", 5, 0.7, "#0055ff", null);' do
                              Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
                                                 :border_width => 5, :border_opacity => 0.7
                            end

      assert_eschaton_output 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, "red", 5, 0.7, "black", null);' do
                              Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
                                                 :border_width => 5, :border_opacity => 0.7,
                                                 :fill_colour => 'black'
                            end

      assert_eschaton_output 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, "red", 5, 0.7, "black", 1);' do
                              Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
                                                 :border_width => 5, :border_opacity => 0.7,
                                                 :fill_colour => 'black', :fill_opacity => 1
                            end
    end 
  end

  
end