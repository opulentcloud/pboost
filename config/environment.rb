# Be sure to restart your server when you modify this file
begin; require 'geokit'; rescue LoadError; end

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/reports )
  config.load_paths += %W( #{RAILS_ROOT}/app/observers )
	config.load_paths << "#{RAILS_ROOT}/vendor/prawn/lib"

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"
	config.gem 'delayed_job', :version => '~> 2.0.3'
	config.gem 'authlogic'
	config.gem "declarative_authorization", :source => 'http://gemcutter.org'
	config.gem 'fastercsv'
	config.gem 'uuidtools'
	config.gem 'pdf-reader'
	config.gem 'daemons'
	config.gem 'geokit'
	config.gem 'GeoRuby', :lib => 'geo_ruby', :version => '1.3.4'
	config.gem 'postgis_adapter'
	config.gem 'ruport'
	config.gem 'will_paginate', :version => '~> 2.3.11', :source => 'http://gemcutter.org'
			
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
	#config.plugins = ['validation_reflection','validatious-on-rails']

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
	config.active_record.observers = [:county_campaign_observer, :federal_campaign_observer, :gis_region_observer, :municipal_campaign_observer, :phone_bank_list_observer, :robocall_campaign_observer, :robocall_list_observer, :sms_campaign_observer, :sms_list_observer, :state_campaign_observer, :survey_observer, :walksheet_observer]

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'Eastern Time (US & Canada)'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  
  #hack for georuby srid issue
  #GeoRuby::SimpleFeatures::DEFAULT_SRID = 4326
	HOST_SITE = 'http://www.politicalboost.org'
end

