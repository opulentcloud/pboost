class VotingHistoryVoter < ActiveRecord::Base

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

	#===== SCOPES =====
	default_scope :order_by => 'election_year DESC'

	#===== ASSOCIATIONS ======
	belongs_to :voter
	
	
end
