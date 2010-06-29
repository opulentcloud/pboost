class CouncilDistrictFilter < Filter

	#====== VALIDATIONS =======
	validates_inclusion_of :string_val, :in => CouncilDistrict.all.map(&:code), :message => 'Please choose a valid Council District', :allow_blank => true

end
