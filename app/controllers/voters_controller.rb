# == Schema Information
#
# Table name: voters
#
#  id                                     :integer          not null, primary key
#  vote_builder_id                        :integer
#  last_name                              :string(32)
#  first_name                             :string(32)
#  middle_name                            :string(32)
#  suffix                                 :string(30)
#  salutation                             :string(32)
#  phone                                  :string(10)
#  home_phone                             :string(10)
#  work_phone                             :string(10)
#  work_phone_ext                         :string(10)
#  cell_phone                             :string(10)
#  email                                  :string(100)
#  party                                  :string(5)
#  sex                                    :string(1)
#  age                                    :integer
#  dob                                    :date
#  dor                                    :date
#  state_file_id                          :integer          not null
#  search_index                           :string(13)
#  created_at                             :datetime
#  updated_at                             :datetime
#  address_id                             :integer
#  search_index2                          :string(12)
#  yor                                    :integer
#  presidential_primary_voting_frequency  :integer          default(0)
#  presidential_general_voting_frequency  :integer          default(0)
#  gubernatorial_primary_voting_frequency :integer          default(0)
#  gubernatorial_general_voting_frequency :integer          default(0)
#  municipal_primary_voting_frequency     :integer          default(0)
#  municipal_general_voting_frequency     :integer          default(0)
#

class VotersController < AuthenticatedUsersController
#  before_filter :require_customer_user!
  before_filter :require_admin_user!, only: [:edit, :update, :destroy]
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

  def edit
  end

  def update
    if @voter.update(voter_params)
      redirect_to @voter, notice: "Voter saved successfully."
    else
      render :edit
    end
  end

  def search
    @petition_headers = (current_user.is_in_role?("Administrator") || current_user.is_in_role?("Employee")) ? PetitionHeader.order(:name) : current_user.petition_headers.order(:name)
    @job_result = DelayedJobResult.find(session[:last_print_job].to_i) if session[:last_print_job].present?
    session[:last_print_job] = nil
    if params[:petitions].present?
      cookies[:last_petition_header] = { :value => params[:petition_header_id], :expires => 365.days.from_now.utc }
    end
    if cookies[:last_petition_header].present?
      unless @petition_headers.pluck(:id).include?(cookies[:last_petition_header].to_i)
        cookies.delete(:last_petition_header)
      end
    end
    @petition_header = PetitionHeader.find(cookies[:last_petition_header]) rescue nil
  	@pg = params[:page] ||= 1
  	@pg = @pg.to_i

    #get list per page settings from form, session or cookie
	  @per_pg = 100
    @include_hoa = params[:hoa].to_s == 'true'

    params[:q] ||= session[:last_search]
    new_keys = []
    begin
      params[:q].each do |qry|
        next unless qry[0].to_s == 'c'
        qry[1].each do |cnd|
          Rails.logger.debug(cnd)
          if cnd[1]['p'] == 'in' # ['votes_election_type'].include?(cnd[1]['a'].first[1]['name'])
            unless cnd[1]['v'].size > 1
              temp_in = cnd[1]['v'].first[1]['value'].split(',')
              new_keys << ["#{cnd[1]['a'].first[1]['name']}_in".to_sym, temp_in, cnd]
            end
          #  params[:q][:combinator] = 'or'
          #  params[:q][:groupings] = []
            #temp_in.each_with_index do |word,index|
              #params[:q][:votes_election_type][index] = word
            #  cnd[1]['v'].first[1]['values'][index] = word
            #  cnd[1]['v'].first[1].delete('value')
            #end
            #cnd[1]['v'].first[1]['values'] = temp_in and cnd[1]['v'].first[1]['value'] = '' if cnd[1]['p'] == 'in'
          end
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

    new_keys.each do |arr|
      params[:q][arr[0]] = arr[1]
      params[:q][:c].delete(arr[2][0])
    end

    @q = Voter.search(params[:q])
    @q2 = Voter.search(params[:q])
    session[:last_search] = params[:q]

    if params[:export].present?
      dj = nil;
      if admin_user?
        dj = Delayed::Job.enqueue VotersExportJob.new(params[:q], @include_hoa)
      else
        dj = Delayed::Job.enqueue ClientVotersExportJob.new(params[:q])
      end
      ret_to = search_voters_path
      ret_to = search_voters_path(hoa: true) if @include_hoa
      redirect_to processing_path(return_url: ret_to, id: dj.id) and return
    end

    if params[:petitions].present? && @petition_header
      delayed_job = Delayed::Job.enqueue PrintPetitionJob.new(@q2.result(distinct: true).includes(:address, :votes).reorder("").map(&:id), params[:petition_header_id], params[:petition_header_circulator_id])
      redirect_to processing_path(id: delayed_job.id, return_url: voters_url), notice: "Building Candidate Petition Form." and return
    end

    if params[:walklists].present? # && admin_user?
      delayed_job = Delayed::Job.enqueue PrintWalksheetJob.new(@q2.result(distinct: true).includes(:address, :votes).reorder("").map(&:id))
      redirect_to processing_path(id: delayed_job.id, return_url: voters_url), notice: "Building Walk-List." and return
    end

    #session[:last_search]['c']['0']['v']['0']['value'] = '' rescue nil
    @voters = @q.result(distinct: true).includes(:address, :votes)

    if @include_hoa == true
      @voters = @voters.joins("INNER JOIN emails ON emails.address = voters.email")
    end

    @party_breakdown = @q2.result(distinct: true).includes(:address, :votes).reorder("").select("party, count(*) as voter_count").group(:party).order("voter_count desc") if params[:party_breakdown].present?
    @precinct_breakdown = @q2.result(distinct: true).includes(:address, :votes).joins("LEFT OUTER JOIN addresses ON addresses.id = voters.address_id").reorder("").select("precinct_code, count(*) as voter_count").group(:precinct_code).order("voter_count desc") if params[:precinct_breakdown].present?

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

  def voter_params
    params.require(:voter).permit(:phone, :home_phone, :work_phone, :work_phone_ext, :cell_phone, :email)
  end

end
