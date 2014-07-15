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
#  voter_id       :integer
#

class VotingHistory < ActiveRecord::Base

  # begin associations
  belongs_to :voter
  # end associations
end
