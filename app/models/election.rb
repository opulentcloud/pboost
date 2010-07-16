class Election < ActiveRecord::Base

	attr_accessor :query_vote_type

	#====== VALIDATIONS =====
	validates_presence_of [:description, :year, :election_type]
	validates_uniqueness_of :description
	validates_uniqueness_of :year, :scope => :election_type
	validates_numericality_of :year
	validates_inclusion_of :election_type, :in =>  VotingHistoryVoter::ELECTION_TYPES.map{|disp, value| value}

end
