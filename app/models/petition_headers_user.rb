# == Schema Information
#
# Table name: petition_headers_users
#
#  petition_header_id :integer
#  user_id            :integer
#

class PetitionHeadersUser < ActiveRecord::Base

  # begin associations
  belongs_to :petition_header
  belongs_to :user
  # end associations
end
