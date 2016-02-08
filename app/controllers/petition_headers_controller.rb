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

class PetitionHeadersController < AuthenticatedUsersController
  def select_circulators
    @petition_header = PetitionHeader.new
    if current_user.is_in_role?("Administrator") || current_user.is_in_role?("Employee")
      @petition_header = PetitionHeader.find(params[:id]) if params[:id].to_i > 0
    elsif current_user.is_in_role?("Customer")
      @petition_header = current_user.petition_headers.find(params[:id]) if params[:id].to_i > 0
    end
    @circulators = @petition_header.circulators.order(:last_name).order(:first_name)
    
    respond_to do |format|
      format.js
    end
  end
end
