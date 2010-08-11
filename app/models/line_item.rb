class LineItem < ActiveRecord::Base

	#===== ASSOCIATIONS =====
	belongs_to :cart
	belongs_to :product
	has_many :line_item_campaigns
	has_many :campaigns, :through => :line_item_campaigns
	has_many :line_item_contact_lists
	has_many :contact_lists, :through => :line_item_contact_lists

	#===== VALIDATIONS ======
  validates_presence_of :cart_id, :product_id, :quantity, :unit_price
	validates_numericality_of :quantity, :only_integer => true
	validates_numericality_of :unit_price, :greater_than_or_equal_to => 0.0001

	#====== INSTANCE METHODS ======
	def full_price
		unit_price * quantity
	end
	
	#===== CLASS METHODS ======
	def self.create_line_item!(the_cart, the_product, the_contact_list, the_campaign, the_quantity, the_unit_price)

		case the_product.category.name
			when 'SmsCampaign' then 
				case the_product.name
					when 'SMS Message' then	the_quantity = the_campaign.voter_count
				else
					raise 'Unknown Product Name'
				end
			else
				raise 'Unknown Product Category'
		end		
		
		LineItem.transaction do
			@line_item = LineItem.create!(:cart => the_cart, :product => the_product, :quantity => the_quantity, :unit_price => the_unit_price)
			@line_item.contact_lists << the_contact_list unless the_contact_list.nil?
			@line_item.campaigns << the_campaign unless the_campaign.nil?
		end
		@line_item
	end

end

