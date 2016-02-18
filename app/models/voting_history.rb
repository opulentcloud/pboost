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

  # begin public class methods
  def self.update_voting_frequencies
    gub_general_query = %{
      UPDATE voters SET gubernatorial_general_voting_frequency = result.gubernatorial_general_voting_frequency
      FROM
      (SELECT v.state_file_id, COUNT(vh.election_year) as gubernatorial_general_voting_frequency FROM voters v
      INNER JOIN voting_histories vh ON vh.state_file_id = v.state_file_id
      WHERE vh.election_year IN (2006, 2010, 2014)
      AND vh.election_type = 'GG'
      GROUP BY v.state_file_id) as result
      WHERE voters.state_file_id = result.state_file_id
    }
    ActiveRecord::Base.connection.execute(gub_general_query, :skip_logging)
    puts "Gubernatorial General History updated..."
    gub_primary_query = %{
      UPDATE voters SET gubernatorial_primary_voting_frequency = result.gubernatorial_primary_voting_frequency
      FROM
      (SELECT v.state_file_id, COUNT(vh.election_year) as gubernatorial_primary_voting_frequency FROM voters v
      INNER JOIN voting_histories vh ON vh.state_file_id = v.state_file_id
      WHERE vh.election_year IN (2006, 2010, 2014)
      AND vh.election_type = 'GP'
      GROUP BY v.state_file_id) as result
      WHERE voters.state_file_id = result.state_file_id
    }
    ActiveRecord::Base.connection.execute(gub_primary_query, :skip_logging)
    puts "Gubernatorial Primary history updated..."
    pres_general_query = %{
      UPDATE voters SET presidential_general_voting_frequency = result.presidential_general_voting_frequency
      FROM
      (SELECT v.state_file_id, COUNT(vh.election_year) as presidential_general_voting_frequency FROM voters v
      INNER JOIN voting_histories vh ON vh.state_file_id = v.state_file_id
      WHERE vh.election_year IN (2004, 2008, 2012)
      AND vh.election_type = 'G'
      GROUP BY v.state_file_id) as result
      WHERE voters.state_file_id = result.state_file_id
    }
    ActiveRecord::Base.connection.execute(pres_general_query, :skip_logging)
    puts "Presidential General history updated...."
    pres_primary_query = %{
      UPDATE voters SET presidential_primary_voting_frequency = result.presidential_primary_voting_frequency
      FROM
      (SELECT v.state_file_id, COUNT(vh.election_year) as presidential_primary_voting_frequency FROM voters v
      INNER JOIN voting_histories vh ON vh.state_file_id = v.state_file_id
      WHERE vh.election_year IN (2004, 2008, 2012)
      AND vh.election_type = 'P'
      GROUP BY v.state_file_id) as result
      WHERE voters.state_file_id = result.state_file_id
    }
    ActiveRecord::Base.connection.execute(pres_primary_query, :skip_logging)
    puts "Presidential Primary history updated..."
  end
  # end public class methods
end
