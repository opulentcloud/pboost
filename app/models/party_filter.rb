class PartyFilter < Filter

	default_scope :order => :int_val

	PARTY_TYPES = [
		#Displayed				stored in db
		[ 'Democrat',					'D' ],
		[ 'Green',						'G' ],
		[ 'Libertarian',			'L' ],
		[ 'Other',						'O' ],
		[ 'Republican',				'R' ]
	]

	#====== VALIDATIONS =======
	validates_inclusion_of :string_val, :in => PARTY_TYPES.map { |disp, value| value}, :if => Proc.new { |pf| pf.string_val != '0' }

end
