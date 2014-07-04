class Role < ActiveRecord::Base

  # begin validations
  validates :name, presence: true
  # end validations
  
  # begin associations
  has_many :users_roles
  has_many :users, through: :users_roles
  # end associations
end
