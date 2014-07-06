class Customers::VoterVerifyController < ApplicationController
  before_filter :require_customer_user!
  
  def new
    #@last_search = session[:last_voter_verify] ||= ""
  end
  
  def search
    @voters = Voter.where(search_index: voter_params[:search_index].to_s.upcase)
    flash[:notification] = "No records found for #{voter_params[:search_index].to_s.upcase}." unless @voters.count > 0
    
    @last_search = session[:last_voter_verify] = voter_params[:search_index].to_s.upcase
    render "new"
  end
  
private
  def voter_params
    @voter_params ||= params.require(:voter).permit(:search_index)
  end
end
