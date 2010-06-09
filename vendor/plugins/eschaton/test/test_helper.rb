# Load up the entire host rails enviroment
require File.dirname(__FILE__) + '/../../../../config/environment'
require 'test_help'

class Test::Unit::TestCase
  cattr_accessor :output_fixture_base
  
  def with_eschaton(&block)
    Eschaton.with_global_script(&block)
  end
  
  def assert_returned_javascript(return_value, javascript_call)
    assert_equal return_value.to_sym, javascript_call
  end
  
  def assert_eschaton_output(output_to_compare, generator = nil, message = nil, &block)  
    if output_to_compare.is_a?(Symbol)
      fixture_base = self.output_fixture_base || '.'
      fixture_file = "#{fixture_base}/output_fixtures/#{output_to_compare}"

      output_to_compare = File.read fixture_file
    end

    output = if block_given?
               Eschaton.global_script.record_for_test(&block).generate
             elsif generator.is_a?(String)
               generator
             else
               generator.generate
             end

    output.strip_each_line!             
    output_to_compare.strip_each_line!
    
    if output_to_compare != output
      left_file = Tempfile.open "left_output"
      left_file << output_to_compare
      left_file.flush

      right_file = Tempfile.open "right_output"
      right_file << output
      right_file.flush

      diff = `diff -u #{left_file.path} #{right_file.path}`
      
      left_file.delete && right_file.delete
        
      flunk "Output difference, please review the below diff.\n\n#{diff}"
    else
      assert true
    end
  end

  def assert_empty(array, message = nil)
    assert array.empty?, message
  end

  def assert_not_empty(array, message = nil)
    assert array.not_empty?, message
  end  

  def assert_blank(value, message = nil)
    assert value.blank?, message
  end

  def assert_not_blank(value, message = nil)
    assert value.not_blank?, message
  end    

  def assert_error(message, exception_class = RuntimeError, &block)
    exception = assert_raise exception_class, &block
    assert_equal(message, exception.message) unless exception.nil? || message.blank?
  end

  # Used to run something once
  def self.setup_once
    yield
  end

  def get_exception
    begin                    
      yield
    rescue => ex
    end

    ex
  end

  def assert_false(value)
    assert_equal false, value, "Expected '#{value}' to be false"
  end

  def assert_true(value)
    assert_equal true, value, "Expected '#{value}' to be true"
  end

end

class EschatonMockView
    
  def url_for(options)
    options.merge!(:only_path => true)
    ActionController::UrlRewriter.new(ActionController::TestRequest.new, nil).rewrite(options)
  end
  
  def render(options)
    "test output for render"
  end

  # For mocking purposes
  def method_missing(method_id, *args)
  end
end

Eschaton.current_view = EschatonMockView.new
