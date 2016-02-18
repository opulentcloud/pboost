# == Schema Information
#
# Table name: petition_headers_circulators
#
#  petition_header_id :integer
#  circulator_id      :integer
#

class PetitionHeadersCirculator < ActiveRecord::Base

  # begin associations
  belongs_to :petition_header
  belongs_to :circulator
  # end associations
end
