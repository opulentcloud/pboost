class Customers::VoterVerifyController < AuthenticatedUsersController
  before_filter :require_customer_user!
  
  def new
    #@last_search = session[:last_voter_verify] ||= ""
    @search_index2 = session[:last_voter_verify] if params[:page].present?
    search if @search_index2
  end
  
  def search
    @pg = params[:page] ||= 1
    voter_dob = Date.parse("#{Date.today.year}-#{voter_params[:dob][0,2]}-#{voter_params[:dob][2,2]}") rescue ""
    @search_index2 ||= Voter.build_search_index2(voter_params[:first_name], voter_params[:last_name],voter_dob)
    @voters = Voter.unscoped.where(search_index2: @search_index2).paginate(page: @pg, per_page: 1)
    flash.now[:notification] = "No records found for #{@search_index2}." unless @voters.total_entries > 0
    
    @last_search = session[:last_voter_verify] = @search_index2
    render "new"
  end
  
private
  def voter_params
    @voter_params ||= params.require(:voter).permit(:first_name, :last_name, :street_no, :dob, :search_index, :search_index2)
  end
end
