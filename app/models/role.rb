# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base

  # begin validations
  validates :name, presence: true
  # end validations
  
  # begin associations
  has_many :users_roles
  has_many :users, through: :users_roles
  # end associations
end
