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

require 'test_helper'

class PetitionHeadersControllerTest < ActionController::TestCase
  setup do
    @petition_header = petition_headers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:petition_headers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create petition_header" do
    assert_difference('PetitionHeader.count') do
      post :create, petition_header: { address: @petition_header.address, baltimore_city: @petition_header.baltimore_city, ltgov_address: @petition_header.ltgov_address, ltgov_name: @petition_header.ltgov_name, name: @petition_header.name, office_and_district: @petition_header.office_and_district, party_affilication_string: @petition_header.party_affilication_string, unaffiliated: @petition_header.unaffiliated, voters_of: @petition_header.voters_of }
    end

    assert_redirected_to petition_header_path(assigns(:petition_header))
  end

  test "should show petition_header" do
    get :show, id: @petition_header
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @petition_header
    assert_response :success
  end

  test "should update petition_header" do
    patch :update, id: @petition_header, petition_header: { address: @petition_header.address, baltimore_city: @petition_header.baltimore_city, ltgov_address: @petition_header.ltgov_address, ltgov_name: @petition_header.ltgov_name, name: @petition_header.name, office_and_district: @petition_header.office_and_district, party_affilication_string: @petition_header.party_affilication_string, unaffiliated: @petition_header.unaffiliated, voters_of: @petition_header.voters_of }
    assert_redirected_to petition_header_path(assigns(:petition_header))
  end

  test "should destroy petition_header" do
    assert_difference('PetitionHeader.count', -1) do
      delete :destroy, id: @petition_header
    end

    assert_redirected_to petition_headers_path
  end
end
