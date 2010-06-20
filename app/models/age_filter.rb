class AgeFilter < Filter

	def self.build_age_range
		a = [['N/A',0]]
		x = 17
		92.times do
			x += 1
			na = [x.to_s, x]
			a.push(na)
		end
		a
	end

	AGE_RANGE = build_age_range

	#====== VALIDATIONS =======
	validates_numericality_of :int_val
	validate :valid_range

	def valid_range
		errors.add_to_base('Maximum Age must be greater than or equal to Minimum Age') if self.max_int_val < self.int_val
	end

end
