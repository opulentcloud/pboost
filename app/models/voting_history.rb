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

class VotingHistory < ActiveRecord::Base

  #exclude some fields from ransack search  
  UNRANSACKABLE_ATTRIBUTES = ['id','state_file_id','election_year','voter_id',
  'election_month', 'created_at','updated_at']

  def self.ransackable_attributes auth_object = nil
    (column_names - UNRANSACKABLE_ATTRIBUTES) + _ransackers.keys
  end

	ELECTION_TYPES = [
		['General',	'G'],
		['Primary',	'P'],
		['Municipal General',	'MG'],
		['Municipal Primary', 'MP'],
		['Gubernatorial General', 'GG'],
		['Gubernatorial Primary', 'GP']
	]
	
	ELECTION_TYPE_CHOICES = [
		['General',	'G'],
		['Primary',	'P']
	]

	VOTING_TYPES = [
    ['Federal Write-In Absentee Ballot', 'F'],
		['Didn\'t Vote', 'N'],
		['Abs', 'A'],
		['Polls', 'P'],
    ['Early Voter', 'E'],
		['Provisional', 'V']
	]

  # begin associations
  belongs_to :voter, foreign_key: :state_file_id
  # end associations
end
