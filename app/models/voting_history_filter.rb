class VotingHistoryFilter < Filter

	default_scope :order => :int_val

	VOTING_TYPES = [
		['Voted', 'Voted'],
		['Didn\'t Vote', 'No Voted'],
		['Abs', 'A'],
		['Polls', 'P'],
		['Provisional', 'V']
	]

	#===== ASSOCIATIONS ======
	belongs_to :election, :foreign_key => :int_val

	#====== VALIDATIONS =======
	validates_inclusion_of :int_val, :in => Election.all.map(&:id), :if => Proc.new { |e| e.int_val != 0 }

end
