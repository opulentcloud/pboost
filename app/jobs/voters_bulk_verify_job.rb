VVerifyJob = Struct.new(:verification_id) do
  def error(job, exception)
  end
end

class VotersBulkVerifyJob < VVerifyJob
  def before(job)
    @job = job
  end
  
  def perform
    verification = Verification.find(verification_id)
    verification.update_attribute(:status, 'Processing')
    verification.build_export!
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
