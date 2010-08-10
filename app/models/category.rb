class Category < ActiveRecord::Base

	default_scope :order => :name

	#===== ASSOCIATIONS ======
	has_many :products

	#====== VALIDATIONS =======	
	validates_uniqueness_of :name
end
