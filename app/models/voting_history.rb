class VotingHistory < ActiveRecord::Base

  # begin associations
  belongs_to :voter
  # end associations
end
