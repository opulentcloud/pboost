if RAILS_ENV != 'test'
	Delayed::Worker.destroy_failed_jobs = false
end

