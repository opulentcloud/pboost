class Admin::DashboardController < ApplicationController
  before_filter :require_admin_user!
  
  def show
  	@pg = params[:page] ||= 1
  	@pg = @pg.to_i
    
    #get list per page settings from form, session or cookie
	  @per_pg = 100

    params['q2'] ||= session[:last_search] ||= {"c"=>{"0"=>{"a"=>{"0"=>{"name"=>"last_name"}}, "p"=>"eq", "v"=>{"0"=>{"value"=>""}}}}, "s"=>session[:last_sort] ||= {"0"=>{"name"=>"last_name", "dir"=>"desc"}}} unless params['q'].present?
    #params['q'] ||= params['q2']

    if params['q'].present?
      params['q2'] = params['q']
    else
      params['q'] = {} #{"s"=>"last_name asc"}    
      params['q']['s'] = params['q2']['s']
    end

    @q = Voter.search(params['q2'])
    @q.build_condition unless @q.conditions.present?
    @q.build_sort(:name => 'last_name', :dir => 'asc') unless @q.sorts.present?

    session[:last_sort] = params['q']['s']
    session[:last_search]['s'] = session[:last_sort]
  end
  
end
