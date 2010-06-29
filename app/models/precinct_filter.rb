class PrecinctFilter < Filter

	#====== VALIDATIONS =======
	validates_inclusion_of :string_val, :in => Precinct.all.map(&:code), :message => 'Please choose a valid Precinct', :allow_blank => true

end
