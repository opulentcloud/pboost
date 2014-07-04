class UsersRole < ActiveRecord::Base
  # begin associations
  belongs_to :user
  belongs_to :role
  # end associations
end
