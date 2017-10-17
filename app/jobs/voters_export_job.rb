VExportJob = Struct.new(:query, :include_hoa) do
  def error(job, exception)
  end
end

class VotersExportJob < VExportJob
  def before(job)
    @job = job
  end

  def perform
    @q = Voter.includes(:address).search(query)
    @voters = @q.result
    @voters = @voters.joins("INNER JOIN emails ON emails.address = voters.email") if include_hoa == true

    #tempfile = Tempfile.new(["voters-export-#{Time.now.to_i}",".xls"])
    #tempfile.write(@voters.to_csv(col_sep: "\t"))
    tempfile = @voters.to_csv({ col_sep: "\t" }, true)
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
