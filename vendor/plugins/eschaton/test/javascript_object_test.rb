require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class JavascriptObjectTest < Test::Unit::TestCase
      
  def test_to_js
    assert_equal 'map', :map.to_js
    assert_equal '["one", "two"]', ['one', 'two'].to_js
    assert_equal 'true', true.to_js
    assert_equal 'false', false.to_js
    assert_equal '{"controls": "small_map", "zoom": 15}', ( {:zoom => 15, :controls => :small_map}).to_js
    assert_equal '{"a": "a", "b": "b", "c": "c"}', ( {:a => 'a', :b => 'b', :c => 'c'}).to_js
  end

  def test_to_js_method
    assert_equal "setZoom", "set_zoom".to_js_method
    assert_equal "setZoom", "zoom=".to_js_method
    assert_equal "setZoomControl", "set_zoom_control".to_js_method
    assert_equal "openInfoWindowHtml", "open_info_window_html".to_js_method
    assert_equal "enableDragging", "enable_dragging!".to_js_method
    assert_equal "show", "show!".to_js_method
  end

  def test_to_js_arguments
   assert_equal '1, 2', [1, 2].to_js_arguments
   assert_equal '1.5, "Hello"', [1.5, "Hello"].to_js_arguments
   assert_equal '[1, 2], "Goodbye"', [[1, 2], "Goodbye"].to_js_arguments
   assert_equal 'true, false', [true, false].to_js_arguments
   assert_equal 'one, two', [:one, :two].to_js_arguments   
   assert_equal '"map", {"controls": "small_map", "zoom": 15}', 
                ['map', {:zoom => 15, :controls => :small_map}].to_js_arguments
  end

  def test_new
    object = Eschaton::JavascriptObject.new(:var => :map)

    assert_equal :map, object.var
    assert object.create_var?    
  end

  def test_existing
    object = Eschaton::JavascriptObject.existing(:var => :map)

    assert_equal :map, object.var
    assert_false object.create_var?    
  end

  def test_translation
    with_eschaton do |script|
      object = Eschaton::JavascriptObject.new(:var => :map)

      object.zoom = 12
      object.set_zoom 12
      object.zoom_in
      object.zoom_out
      object.return_to_saved_position
      object.open_info_window(:location, "Howdy!")
      object.update_markers [1, 2, 3]
      object.set_options_on('map', {:zoom => 15, :controls => :small_map})
      object.enable_dragging!

      assert_eschaton_output 'map.setZoom(12);
                             map.setZoom(12);
                             map.zoomIn();
                             map.zoomOut();
                             map.returnToSavedPosition();
                             map.openInfoWindow(location, "Howdy!");
                             map.updateMarkers([1, 2, 3]);
                             map.setOptionsOn("map", {"controls": "small_map", "zoom": 15});
                             map.enableDragging();', 
                             script
    end
  end
    
  def test_script
    script = Eschaton.javascript_generator
    object = Eschaton::JavascriptObject.existing(:var => 'map', :script => script)
    
    assert script, object.script
  end
  
  def test_add_to_script
    with_eschaton do |script|
      object = Eschaton::JavascriptObject.new
      
      object << "var i = 1;"
      
      assert_eschaton_output "var i = 1;", script
    end
  end
  
  def test_question_mark_translation
    with_eschaton do |script|
      object = Eschaton::JavascriptObject.new(:var => :array)

      return_value = object.index_of?("A value")

      assert return_value.is_a?(Symbol)
      assert_equal 'array.indexOf("A value")'.to_sym, return_value    
      assert_blank script.generate      
    end
  end
    
end
