# == Schema Information
#
# Table name: users_roles
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  role_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  users_id   :integer
#  roles_id   :integer
#

class UsersRole < ActiveRecord::Base
  # begin associations
  belongs_to :user
  belongs_to :role
  # end associations
end
