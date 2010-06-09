require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class KernelGeneratorTest < Test::Unit::TestCase

  def test_record
    script = Eschaton.javascript_generator

    script << "// This is before recording"
    record = script.record_for_test do
               script << "// This is within recording"
             end

    script << "// This is after recording"

    assert_equal "// This is before recording\n" << 
                 "// This is within recording\n" << 
                 "// This is after recording", script.generate    
    assert_equal "// This is within recording", record.generate
  end
  
  def test_if_statement
    with_eschaton do |script|
      assert_eschaton_output :if_statement do
                              script.if("x == 1"){
                                script.alert("x is 1!")
                              }
                            end


      assert_eschaton_output :if_statement_using_local_var do
                              script.if("local_var"){
                                script.alert("there was a local var")
                              }
                            end
    end
  end
  
  def test_if_statement
    with_eschaton do |script|
      assert_eschaton_output :unless_statement do
                              script.unless("x == 1"){
                                script.alert("x is not 1!")
                              }
                            end

      assert_eschaton_output :unless_statement_using_local_var do
                              script.unless("local_var"){
                                script.alert("there was a local var")
                              }
                            end
    end  
  end
  
end