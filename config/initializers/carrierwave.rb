CarrierWave.configure do |config|
  if %w(development staging production).include?(Rails.env)
    config.storage = :fog
    config.fog_authenticated_url_expiration = 600 
    config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAIANNNWEEWPMDOK3Q',     # required
    :aws_secret_access_key  => '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',  # required
    :region                 => 'us-west-1',                  # optional, defaults to 'us-east-1'
    :host                   => 's3.amazonaws.com',           # optional, defaults to nil
    :endpoint               => 'https://s3-us-west-1.amazonaws.com'    # optional, defaults to nil
  }
  config.fog_directory  = ENV['AWS_S3_BUCKET']               # required
  config.fog_public     = false                              # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}  
  elsif %w(test).include?(Rails.env)
    config.permissions = 0666
    config.directory_permissions = 0777
    config.storage = :file
    config.enable_processing = !Rails.env.test?
  end
end
