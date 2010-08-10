class Order < ActiveRecord::Base
	
	#====== ASSOCIATIONS ======
	belongs_to :cart
	has_many :transactions, :class_name => 'OrderTransaction'
	
	#====== ACCESSORS =======
	attr_accessor :card_number, :card_verification
	
	#===== VALIDATIONS ======
	validate_on_create :validate_card
	
	def price_in_cents
		(cart.total_price*100).round
	end
	
private

	def purchase_options
		{
			:ip => ip_address
			:billing_address => {
				:name => 'Mark Wilson',
				:address1 => '183 Valley View Terrace',
				:city => 'Mission Viejo',
				:state => 'CA',
				:country => 'US',
				:zip => '92692'
			}
		}
	end
	
	def validate_card
		unless credit_card.valid?
			credit_card.errors.full_messages.each do |message|
				errors.add_to_base message
			end		
		end
	end
	
	def credit_card
		@credit_card ||= ActiveMerchant::Billing::CreditCard.new(
			:type => card_type,
			:number => card_number,
			:verification_value => card_verification,
			:month => card_expires_on.month,
			:year => card_expires_on.year,
			:first_name => first_name
			:last_name => last_name
		)
	end
	
end
