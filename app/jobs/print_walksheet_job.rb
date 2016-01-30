PWSJob = Struct.new(:voter_ids) do
  def error(job, exception)
  end
end

class PrintWalksheetJob < PWSJob
  def before(job)
    @job = job
  end
  
  def perform
    tempfile = Tempfile.new(["walksheet",".pdf"])
    tempfile.write(WalksheetReportPdf.new(voter_ids).render.force_encoding("UTF-8"))
    result = DelayedJobResult.new(job_id: @job.id)
    result.build_batch_file(mime_type: 'applicaton/pdf', 
      origin_url: 'na',
      description: 'walksheet')
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
    subject = "PrintWalksheetJob Failed"
    AdminMailer.notification(subject, job.last_error).deliver
    super if defined?(super)
  end
end
