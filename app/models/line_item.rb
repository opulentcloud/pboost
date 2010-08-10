class LineItem < ActiveRecord::Base

	#===== ASSOCIATIONS =====
	belongs_to :cart
	belongs_to :product
	has_many :campaigns, :through => :line_item_campaigns
	has_many :contact_lists, :through => :line_item_contact_lists

	#===== VALIDATIONS ======
	validates_presence_of :cart_id, :product_id, :quantity, :unit_price
	validate :has_campaign_or_list
	validates_numericality_of :quantity => :only_integer => true
	validates_numericality_of :unit_price => :greater_than_or_equal_to => 0.0001

	def has_campaign_or_list
		if !((campaigns.count + contact_lists.count) == quantity)
			errors.add_to_base('Quantity does not match services we have in your Cart.')
		end
	end
	
	def full_price
		unit_price * quantity
	end
	
end
