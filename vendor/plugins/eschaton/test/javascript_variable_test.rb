require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class JavascriptVariableTest < Test::Unit::TestCase

  def test_new_variable
    with_eschaton do |script|
      assert_eschaton_output 'var points = new Array();
                             points.push("One");
                             points.push("Two");' do
                              points = Eschaton::JavascriptVariable.new(:name => :points, :value => "new Array()")
                              points.push("One")
                              points.push("Two")                              
                            end
    end
  end

  def test_existing_variable
    with_eschaton do |script|
      assert_eschaton_output 'points.push("One");
                             points.push("Two");'do
                              points = Eschaton::JavascriptVariable.existing(:name => :points)
                              points.push("One")
                              points.push("Two")                              
                            end
    end
  end

  def test_method_translation
    with_eschaton do |script|
      assert_eschaton_output 'var points = new Array();
                             points.push("One");
                             points.push("Two");
                             points.translateToCamelCase();
                             points.withTwoArguments("One", 2);' do
                              points = Eschaton::JavascriptVariable.new(:name => :points, :value => "new Array()")
                              points.push("One")
                              points.push("Two")
                              points.translate_to_camel_case!
                              points.with_two_arguments("One", 2)
                            end
    end
  end
  
  def test_array_accessor
    with_eschaton do |script|
      points = Eschaton::JavascriptVariable.new(:name => :points, :value => "new Array()")

      assert_returned_javascript 'points[1]', points[1]
      assert_returned_javascript 'points["Hello"]', points["Hello"]
      assert_returned_javascript 'points[a_marker]', points[:a_marker]

      assert_eschaton_output 'points[1] = 1;' do
                              points[1] = 1
                            end

      assert_eschaton_output 'points[1] = "Hello";' do
                              points[1] = "Hello"
                            end

      assert_eschaton_output 'points[1] = a_marker;' do
                              points[1] = :a_marker
                            end
    end    
  end
  
  def test_each
    with_eschaton do |script|
      the_array = Eschaton::JavascriptVariable.new(:var => :my_array, :value => '["one", "two", "three"]')
      
      assert_eschaton_output 'jQuery.each(my_array, function(index, item){
                               alert(item);
                              });' do
        the_array.each do |element|
          script << "alert(#{element});"
        end                             
      end
      
    end    
  end

  def test_each_with_index
    with_eschaton do |script|
      the_array = Eschaton::JavascriptVariable.new(:var => :my_array, :value => '["one", "two", "three"]')
      
      assert_eschaton_output "jQuery.each(my_array, function(index, item){
                                alert(item + ' is at ' + index);
                              });" do
        the_array.each_with_index do |element, index|
          script << "alert(#{element} + ' is at ' + #{index});"
        end            
      end
      
    end    
  end

end