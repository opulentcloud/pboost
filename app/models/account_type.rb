class AccountType < ActiveRecord::Base
	#===== SCOPES =====
	default_scope :order => 'account_types.name'

	#===== VALIDATIONS =====
	validates_presence_of :name
	validates_uniqueness_of :name
end
