class ProcessingController < AuthenticatedUsersController
  before_action :set_job

  def show
    @respond_with_div = params[:return_url].start_with?("div#") if params[:return_url].present?
    @job_result = DelayedJobResult.where(job_id: params[:id].to_i).first unless @job
    @return_url = prepare_return_url
    respond_to do |format| 
      format.html { 
        redirect_to @job_result.batch_file.attached_file.url and return if @job_result.present? && @job_result.try(:batch_file).try(:attached_file).try(:url).present?
        redirect_to params[:return_url] and return unless @job.present? 
      }
      format.js { }
    end
  end

  private
    def prepare_return_url
      return params[:return_url] if @respond_with_div == true
      return params[:return_url] unless @job_result.present?
      return URI.encode(@job_result.batch_file.attached_file.url)
      # no longer used
      uri = URI.parse(params[:return_url])
      new_query = URI.decode_www_form((uri.query || '')) << ["jrid", "#{@job_result.id}"]
      uri.query = URI.encode_www_form(new_query)
      uri.to_s
    end

    def set_job
      @job = Delayed::Job.where(id: params[:id].to_i).first
    end
end
