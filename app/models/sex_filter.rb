class SexFilter < Filter

	SEX_TYPES = [
		#Displayed				stored in db
		[ 'Female',					'F' ],
		[ 'Male',						'M' ],
		[ 'All',						'A' ]
	]

	#====== VALIDATIONS =======
	validates_presence_of :string_val, :message => 'Please choose Female, Male or All'
	validates_inclusion_of :string_val, :in => SEX_TYPES.map {|disp, value| value}, :message => 'Please choose a sex'

end
