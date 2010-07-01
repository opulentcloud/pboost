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
	validate :valid_int_val

	#===== EVENTS =====
	def before_validation
		if ['Any','All'].include?(self.string_val)
			self.int_val = nil	
		end
		
		true
	end	

	#===== CLASS METHODS =====
	def valid_int_val
		return true unless ['At Least','Exactly','No More Than'].include?(self.string_val)
		return true unless self.int_val < 1
		errors.add(:int_val, 'must be greater than zero')
	end

end
