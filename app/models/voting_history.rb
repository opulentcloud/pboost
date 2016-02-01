# == Schema Information
#
# Table name: voting_histories
#
#  id             :integer          not null, primary key
#  election_year  :integer
#  election_month :integer
#  election_type  :string(2) # G-General, MG-Muni General, MP-Muni Primary, P-Primary
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

	ELECTION_TYPES = [
		['General',	'G'],
		['Primary',	'P'],
		['Municipal General',	'MG'],
		['Municipal Primary', 'MP']
	]
	
	ELECTION_TYPE_CHOICES = [
		['General',	'G'],
		['Primary',	'P']
	]

	VOTING_TYPES = [
		['Voted', 'Y'],
		['Didn\'t Vote', 'N'],
		['Abs', 'A'],
		['Polls', 'P'],
		['Provisional', 'V']
	]

  # begin associations
  belongs_to :voter, foreign_key: :state_file_id
  # end associations
end
