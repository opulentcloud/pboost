# == Schema Information
#
# Table name: addresses
#
#  id                    :integer          not null, primary key
#  street_no             :string(10)
#  street_no_half        :string(10)
#  street_prefix         :string(10)
#  street_name           :string(50)
#  street_type           :string(10)
#  street_suffix         :string(10)
#  apt_type              :string(10)
#  apt_no                :string(20)
#  city                  :string(32)
#  state                 :string(2)
#  zip5                  :string(5)
#  zip4                  :string(4)
#  county_name           :string(32)
#  precinct_name         :string(32)
#  precinct_code         :string(32)
#  cd                    :string(3)
#  sd                    :string(3)
#  hd                    :string(3)
#  comm_dist_code        :string(3)
#  lat                   :decimal(15, 10)
#  lng                   :decimal(15, 10)
#  geo_failed            :boolean
#  address_hash          :string(32)
#  is_odd                :boolean
#  street_no_int         :integer
#  created_at            :datetime
#  updated_at            :datetime
#  ward_district         :string(10)
#  municipal_district    :string(10)
#  commissioner_district :string(10)
#  school_district       :string(10)
#

require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
