class PetitionHeadersUser < ActiveRecord::Base

  # begin associations
  belongs_to :petition_header
  belongs_to :user
  # end associations
end
