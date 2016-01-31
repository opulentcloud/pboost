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

  #exclude some fields from ransack search  
  UNRANSACKABLE_ATTRIBUTES = ['id','voter_id','created_at','updated_at']

  def self.ransackable_attributes auth_object = nil
    (column_names - UNRANSACKABLE_ATTRIBUTES) + _ransackers.keys
  end

  # begin associations
  belongs_to :voter
  # end associations
end
