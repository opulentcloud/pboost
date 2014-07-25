class Customers::VerificationsController < AuthenticatedUsersController
  before_filter :require_customer_user!
  before_filter :set_vars, only: [:destroy]

  def index
    #get page number settings
  	@pg = params[:page] ||= 1
  	@pg = @pg.to_i
    
    #get list per page settings from form, session or cookie
	  @per_pg = params[:per_page] ||= 25
   
    @verifications = current_user.verifications.order("updated_at DESC").paginate(:page => @pg, :per_page => @per_pg)
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @verification = current_user.verifications.build
  end

  def create
		if !params[:verification][:attached_file]
			flash.now[:notice] = 'You have not attached any file to upload.'
			render :new
			return
		end
    @verification = current_user.verifications.build
    @verification.build_import(attached_file: params[:verification][:attached_file], mime_type: 'plain/text', origin_url: 'uploaded csv', description: 'uploaded url')
    @verification.status = 'New'
    if @verification.save
      delayed_job = Delayed::Job.enqueue VotersBulkVerifyJob.new(@verification.id)
      redirect_to processing_path(id: delayed_job.id, return_url: verifications_url), notice: "Verify Your Voters." and return
    else
			flash.now[:error] = 'Your file failed to upload properly.' unless @verification.errors.count > 0
      render :new
    end
  end  

  def destroy
    @verification.destroy
    respond_to do |format|
      format.html { redirect_to verifications_path, notice: 'Voter Verification file was successfully deleted.' }
      format.json { head :no_content }
    end
  end
  
private

  def set_vars
    @verification = current_user.verifications.find(params[:id])
  end
end
