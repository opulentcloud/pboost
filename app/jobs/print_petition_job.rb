PPetitionJob = Struct.new(:voter_ids, :petition_header_id) do
  def error(job, exception)
  end
end

class PrintPetitionJob < PPetitionJob
  def before(job)
    @job = job
  end
  
  def perform
    tempfile = Tempfile.new(["candidate-petition-form",".pdf"])
    tempfile.write(CandidatePetitionFormReportPdf.new(petition_header_id, voter_ids).render.force_encoding("UTF-8"))
    result = DelayedJobResult.new(job_id: @job.id)
    result.build_batch_file(mime_type: 'applicaton/pdf', 
      origin_url: 'na',
      description: 'candidate petition form')
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
