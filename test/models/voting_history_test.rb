# == Schema Information
#
# Table name: voting_histories
#
#  id             :integer          not null, primary key
#  election_year  :integer
#  election_month :integer
#  election_type  :string(2)
#  voter_type     :string(1)
#  created_at     :datetime
#  updated_at     :datetime
#  state_file_id  :integer          not null
#

require 'test_helper'

class VotingHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
