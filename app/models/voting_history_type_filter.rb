class VotingHistoryTypeFilter < Filter

	VOTING_HISTORY_TYPES = [
		['Any', 'Any'],
		['All', 'All'],
		['At Least', 'At Least'],
		['Exactly', 'Exactly'],
		['No More Than', 'No More Than']
	]

	#====== VALIDATIONS =======
	validates_inclusion_of :string_val, :in => VOTING_HISTORY_TYPES.map{ |id,value| value }

end
