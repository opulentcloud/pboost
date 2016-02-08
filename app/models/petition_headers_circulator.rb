class PetitionHeadersCirculator < ActiveRecord::Base

  # begin associations
  belongs_to :petition_header
  belongs_to :circulator
  # end associations
end
