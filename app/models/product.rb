class Product < ActiveRecord::Base

	default_scope :order => :name

	#===== ASSOCIATIONS ======
	belongs_to :category
  
  #===== VALIDATIONS ======
  validates_uniqueness_of :name
  validates_presence_of :name, :category_id, :price, :description
  validates_numericality_of :price
	validate :price_must_be_at_least_a_value

	#===== INSTANCE METHODS =====
  def price_must_be_at_least_a_value
  	errors.add(:price, 'should be at least 0.0001') if price.nil? || price < 0.0001
  end
  
end
