class PartyFilter < Filter

	default_scope :order => :int_val

	#===== ASSOCIATIONS ======
	belongs_to :party, :foreign_key => :int_val

	#====== VALIDATIONS =======
	validates_inclusion_of :string_val, :in => Party.all.map { |name,code| code}, :if => Proc.new { |pf| pf.string_val != '0' }

end
