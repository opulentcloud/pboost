# == Schema Information
#
# Table name: petition_headers
#
#  id                  :integer          not null, primary key
#  voters_of           :string(255)      default("")
#  baltimore_city      :boolean          default(FALSE)
#  party_affiliation   :string(255)      default("")
#  unaffiliated        :boolean          default(FALSE)
#  name                :string(255)      default("")
#  address             :string(255)      default("")
#  office_and_district :string(255)      default("")
#  ltgov_name          :string(255)      default("")
#  ltgov_address       :string(255)      default("")
#  created_at          :datetime
#  updated_at          :datetime
#

class PetitionHeader < ActiveRecord::Base

  # begin associations
  has_many :petition_headers_circulators, dependent: :destroy
  has_many :circulators, through: :petition_headers_circulators
  has_many :petition_headers_users, dependent: :destroy
  has_many :users, through: :petition_headers_users
  # end associations
end
