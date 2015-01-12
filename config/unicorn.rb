listen 8080, :tcp_nopush => false
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
timeout 120
preload_app true

@delayed_job_pid = nil

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  #@delayed_job_pid ||= spawn("bundle exec rake jobs:work")
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  if defined?(ActiveRecord::Base)
    #config = Rails.application.config.database_configuration[Rails.env]
    #config['adapter'] = 'postgis'
    ActiveRecord::Base.establish_connection
  end
end
