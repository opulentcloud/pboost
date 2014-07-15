# == Schema Information
#
# Table name: delayed_job_results
#
#  id         :integer          not null, primary key
#  job_id     :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class DelayedJobResultTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
