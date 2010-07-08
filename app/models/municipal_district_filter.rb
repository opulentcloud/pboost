class MunicipalDistrictFilter < Filter

	#====== VALIDATIONS =======
	validates_inclusion_of :string_val, :in => MunicipalDistrict.all.map(&:code), :message => 'Please choose a valid Municipal District', :allow_blank => true

end
