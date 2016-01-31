# == Schema Information
#
# Table name: verifications
#
#  id         :integer          not null, primary key
#  impfile    :string(255)
#  expfile    :string(255)
#  status     :string(50)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

require 'test_helper'

class VerificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
