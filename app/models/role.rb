class Role < ActiveRecord::Base
	#===== SCOPES =====
	default_scope :order => "roles.name ASC"

	named_scope :admin, :conditions => "roles.name = 'Administrator'"
	named_scope :customer, :conditions => "roles.name = 'Customer'"
	named_scope :employee, :conditions => "roles.name = 'Employee'"

	#===== ASSOCIATIONS =====	
	has_and_belongs_to_many :users

	#====== VALIDATIONS ======
	validates_presence_of :name
	validates_uniqueness_of :name

end
