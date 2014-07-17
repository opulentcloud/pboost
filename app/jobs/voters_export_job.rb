VExportJob = Struct.new(:query) do
  def error(job, exception)
  end
end

class VotersExportJob < VExportJob
  def before(job)
    @job = job
  end
  
  def perform
#    CommercialInvoice.print_multi!(user_name, order_ids, save_to_dropbox, @job.id)
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
