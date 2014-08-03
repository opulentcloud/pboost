class VotersController < ApplicationController
#  before_filter :require_customer_user!
  before_action :set_voter, only: [:show, :edit, :update, :destroy]

  def index
    if params[:clear].present?
      session[:last_search] = nil 
      session[:last_sort] = nil
    end
    @job_result = DelayedJobResult.find(session[:last_print_job].to_i) if session[:last_print_job].present?
    session[:last_print_job] = nil
  	@pg = params[:page] ||= 1
  	@pg = @pg.to_i
    
    #get list per page settings from form, session or cookie
	  @per_pg = 100

    #params['q2'] ||= session[:last_search] ||= {"c"=>{"0"=>{"a"=>{"0"=>{"name"=>"last_name"}}, "p"=>"eq", "v"=>{"0"=>{"value"=>""}}}}, "s"=>session[:last_sort] ||= {"0"=>{"name"=>"last_name", "dir"=>"desc"}}} unless params['q'].present?

    params['q2'] ||= session[:last_search] ||= {"c"=>{"0"=>{"a"=>{"0"=>{"name"=>"last_name"}}, "p"=>"eq", "v"=>{"0"=>{"value"=>""}}}}, "s"=>session[:last_sort] ||= {"0"=>{"name"=>"", "dir"=>""}}} unless params['q'].present?

    if params['q'].present?
      params['q2'] = params['q']
    else
      params['q'] = {} #{"s"=>"last_name asc"}    
      params['q']['s'] = params['q2']['s']
    end

    @q = Voter.search(params['q2'])
    @q.build_condition unless @q.conditions.present?
    #@q.build_sort #(:name => 'last_name', :dir => 'asc') unless @q.sorts.present?

    session[:last_sort] = params['q']['s']
    session[:last_search]['s'] = session[:last_sort]
  end

  def show
    @use_modal = params[:use_modal] == 'true'
    render 'show_modal', layout: false and return if @use_modal
  end
  
  def search
    @job_result = DelayedJobResult.find(session[:last_print_job].to_i) if session[:last_print_job].present?
    session[:last_print_job] = nil
    cookies[:last_petition_header] = { :value => params[:petition_header_id], :expires => 365.days.from_now.utc } if params[:petitions].present?
  	@pg = params[:page] ||= 1
  	@pg = @pg.to_i
    
    #get list per page settings from form, session or cookie
	  @per_pg = 100

    params[:q] ||= session[:last_search]
    begin
      params[:q].each do |qry|
        next unless qry[0].to_s == 'c'
        qry[1].each do |cnd|
          Rails.logger.debug(cnd)
          if Voter::DATE_SEARCH_FIELDS.include?(cnd[1]['a'].first[1]['name'])
            temp_dt = cnd[1]['v'].first[1]['value']
            cnd[1]['p'] = "date_equals" if cnd[1]['p'] == 'equals'
            cnd[1]['p'] = "date_equals" if cnd[1]['p'] == 'cont'
            if temp_dt =~ /\//
              temp_dt = Date.strptime(temp_dt, '%m/%d/%Y')
            else
              temp_dt = Chronic.parse(temp_dt)
            end
            cnd[1]['v'].first[1]['value'] =  temp_dt.to_date.to_s(:db)
          end
        end
      end
    rescue Exception => ex
      debugger if Rails.env.development?
      Rails.logger.debug(ex.backtrace)    
    end

    @q = Voter.includes(:address).search(params[:q])
    @q2 = Voter.search(params[:q])
    session[:last_search] = params[:q]

    if params[:export].present? && admin_user?
      dj = Delayed::Job.enqueue VotersExportJob.new(params[:q])
      redirect_to processing_path(return_url: search_voters_path, id: dj.id) and return
    end

    if params[:petitions].present? && admin_user?
      delayed_job = Delayed::Job.enqueue PrintPetitionJob.new(@q2.result.reorder("").map(&:id), params[:petition_header_id])
      redirect_to processing_path(id: delayed_job.id, return_url: voters_url), notice: "Building Candidate Petition Form." and return
    end

    #session[:last_search]['c']['0']['v']['0']['value'] = '' rescue nil
    @voters = @q.result

    @party_breakdown = @q2.result.reorder("").select("party, count(*) as voter_count").group(:party).order("voter_count desc") if params[:party_breakdown].present?
    @precinct_breakdown = @q2.result.reorder("").select("precinct_code, count(*) as voter_count").group(:precinct_code).order("voter_count desc") if params[:precinct_breakdown].present?

    respond_to do |format|
      format.html {
        @voters = @voters.paginate(:page => @pg, :per_page => @per_pg)
        @q.build_condition if @q.conditions.empty?
        @q.build_sort if @q.sorts.empty?
      }
      format.csv { 
        access_denied and return unless admin_user?
        send_data @voters.to_csv, 
          filename: "voter-export-#{Time.now.to_i}.csv",
          type: :csv,
          disposition: "#{ENV['PDF_DISPOSITION']}"
      }
      format.xlsx { access_denied unless admin_user? }
      format.xls { 
        throw access_denied and return unless admin_user?
        send_data @voters.to_csv(col_sep: "\t"),
          filename: "voter-export-#{Time.now.to_i}.xls",
          type: :xls,
          disposition: "#{ENV['PDF_DISPOSITION']}"
      }
    end
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_voter
    @voter = Voter.find(params[:id])
  end

end
