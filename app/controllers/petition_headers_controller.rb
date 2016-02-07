class PetitionHeadersController < AuthenticatedUsersController
  def select_circulators
    @petition_header = params[:id].to_i > 0 ? PetitionHeader.find(params[:id]) : PetitionHeader.new
    @circulators = @petition_header.circulators.order(:last_name).order(:first_name)
    
    respond_to do |format|
      format.js
    end
  end
end
