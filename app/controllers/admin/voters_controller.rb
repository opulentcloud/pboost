class Admin::VotersController < ApplicationController
  before_filter :require_admin_user!
  
  def search
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
    session[:last_search] = params[:q]

    #session[:last_search]['c']['0']['v']['0']['value'] = '' rescue nil
    @voters = @q.result

    @party_breakdown = @voters.reorder("").select("party, count(*) as voter_count").group(:party).order("voter_count desc") if params[:party_breakdown].present?
    @precinct_breakdown = @voters.reorder("").select("precinct_code, count(*) as voter_count").group(:precinct_code).order("voter_count desc") if params[:precinct_breakdown].present?

    respond_to do |format|
      format.html {
        @voters = @voters.paginate(:page => @pg, :per_page => @per_pg)
        @q.build_condition if @q.conditions.empty?
        @q.build_sort if @q.sorts.empty?
      }
      format.csv { 
        send_data @voters.to_csv, 
          filename: "voter-export-#{Time.now.to_i}.csv",
          type: :csv,
          disposition: "#{ENV['PDF_DISPOSITION']}"
      }
      format.xlsx { }
      format.xls { 
        send_data @voters.to_csv(col_sep: "\t"),
          filename: "voter-export-#{Time.now.to_i}.xls",
          type: :xls,
          disposition: "#{ENV['PDF_DISPOSITION']}"
      }
    end
  end

end
