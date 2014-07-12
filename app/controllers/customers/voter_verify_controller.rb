class Customers::VoterVerifyController < AuthenticatedUsersController
  before_filter :require_customer_user!
  
  def new
    #@last_search = session[:last_voter_verify] ||= ""
    @search_index = session[:last_voter_verify] if params[:page].present?
    search if @search_index
  end
  
  def search
    @pg = params[:page] ||= 1
    @search_index ||= Voter.build_search_index(voter_params[:first_name], voter_params[:last_name],voter_params[:street_no])
    @voters = Voter.unscoped.where(search_index: @search_index).paginate(page: @pg, per_page: 1)
    flash[:notification] = "No records found for #{@search_index}." unless @voters.total_entries > 0
    
    @last_search = session[:last_voter_verify] = @search_index
    render "new"
  end
  
private
  def voter_params
    @voter_params ||= params.require(:voter).permit(:first_name, :last_name, :street_no, :search_index)
  end
end
