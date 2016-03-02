CVExportJob = Struct.new(:query) do
  def error(job, exception)
  end
end

class ClientVotersExportJob < CVExportJob
  def before(job)
    @job = job
  end
  
  def perform
    @q = Voter.includes(:address).search(query)
    @voters = @q.result
    
    #tempfile = Tempfile.new(["voters-export-#{Time.now.to_i}",".xls"])
    #tempfile.write(@voters.to_csv(col_sep: "\t"))
    tempfile = @voters.to_csv({ col_sep: "\t" }, true, :client)
    result = DelayedJobResult.new(job_id: @job.id)
    result.build_batch_file(mime_type: 'applicaton/xls', 
      origin_url: 'na',
      description: 'voters export file')
    result.batch_file.attached_file = tempfile
    result.save!
  end
  
  def max_runtime
    15.minutes
  end
  
  def max_attempts
    1
  end

  def failure(job)
    subject = "VotersExportJob Failed"
    AdminMailer.notification(subject, job.last_error).deliver
    super if defined?(super)
  end
end
