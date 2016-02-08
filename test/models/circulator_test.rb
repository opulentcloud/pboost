# == Schema Information
#
# Table name: circulators
#
#  id           :integer          not null, primary key
#  first_name   :string(32)
#  last_name    :string(32)
#  name         :string(65)       not null
#  address      :string(100)      not null
#  city         :string(32)       not null
#  state        :string(2)        not null
#  zip          :string(5)        not null
#  phone_number :string(10)       not null
#  created_at   :datetime
#  updated_at   :datetime
#

require 'test_helper'

class CirculatorTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
