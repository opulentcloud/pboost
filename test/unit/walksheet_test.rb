require 'test_helper'

class WalksheetTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Walksheet.new.valid?
  end
end
