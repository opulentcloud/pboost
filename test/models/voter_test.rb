# == Schema Information
#
# Table name: voters
#
#  id                                     :integer          not null, primary key
#  vote_builder_id                        :integer
#  last_name                              :string(32)
#  first_name                             :string(32)
#  middle_name                            :string(32)
#  suffix                                 :string(30)
#  salutation                             :string(32)
#  phone                                  :string(10)
#  home_phone                             :string(10)
#  work_phone                             :string(10)
#  work_phone_ext                         :string(10)
#  cell_phone                             :string(10)
#  email                                  :string(100)
#  party                                  :string(5)
#  sex                                    :string(1)
#  age                                    :integer
#  dob                                    :date
#  dor                                    :date
#  state_file_id                          :integer          not null
#  search_index                           :string(13)
#  created_at                             :datetime
#  updated_at                             :datetime
#  address_id                             :integer
#  search_index2                          :string(12)
#  yor                                    :integer
#  presidential_primary_voting_frequency  :integer          default(0)
#  presidential_general_voting_frequency  :integer          default(0)
#  gubernatorial_primary_voting_frequency :integer          default(0)
#  gubernatorial_general_voting_frequency :integer          default(0)
#  municipal_primary_voting_frequency     :integer          default(0)
#  municipal_general_voting_frequency     :integer          default(0)
#

require 'test_helper'

class VoterTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
