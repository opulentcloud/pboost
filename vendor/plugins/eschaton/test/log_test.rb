require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)
    
class LogTest < Test::Unit::TestCase
  
  def test_write
    with_eschaton do
      assert_equal 'GLog.writeHtml("This is a log message!");', Google::Log.write("This is a log message!")
      assert_equal 'GLog.writeHtml("Line 1<br/>Line 2");', Google::Log.write("Line 1<br/>Line 2")
    end
  end


  def test_write_to_script
    assert_eschaton_output 'GLog.writeHtml("This is a log message!");
                           GLog.writeHtml("Line 1<br/>Line 2");',
                          with_eschaton {
                            Google::Log.write("This is a log message!")
                            Google::Log.write("Line 1<br/>Line 2")
                          }
  end

end
