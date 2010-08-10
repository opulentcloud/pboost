class Cart < ActiveRecord::Base

	#===== ASSOCIATIONS ======
	has_many :line_items
	has_one :order
	belongs_to :user

	def total_price
		line_items.to_a.sum(&:full_price).round(2)
	end	
	
end
