# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100818172555) do

  create_table "account_types", :force => true do |t|
    t.column "name", :string, :limit => 100, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "account_types", ["name"], :name => "index_account_types_on_name", :unique => true

  create_table "accounts", :force => true do |t|
    t.column "type", :string, :limit => 14
    t.column "organization_id", :integer
    t.column "current_balance", :decimal, :precision => 11, :scale => 2, :default => 0.0
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "accounts", ["id", "type"], :name => "index_accounts_on_id_and_type"
  add_index "accounts", ["organization_id"], :name => "index_accounts_on_organization_id", :unique => true

  create_table "address_infos", :force => true do |t|
    t.column "first_name", :string, :limit => 32, :null => false
    t.column "last_name", :string, :limit => 32, :null => false
    t.column "address1", :string, :limit => 64, :null => false
    t.column "address2", :string, :limit => 64, :default => ""
    t.column "city", :string, :limit => 32, :null => false
    t.column "state", :string, :limit => 2, :null => false
    t.column "country", :string, :limit => 2, :null => false
    t.column "postal_code", :string, :limit => 10, :null => false
    t.column "type", :string, :limit => 100
    t.column "string", :string, :limit => 100
    t.column "addressable_id", :integer
    t.column "addressable_type", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "address_infos", ["addressable_id", "addressable_type"], :name => "index_address_infos_on_addressable_id_and_addressable_type"
  add_index "address_infos", ["id", "type"], :name => "index_address_infos_on_id_and_type", :unique => true
  add_index "address_infos", ["type"], :name => "index_address_infos_on_type"

  create_table "addresses", :force => true do |t|
    t.column "street_no", :string, :limit => 5
    t.column "street_no_half", :string, :limit => 3
    t.column "street_prefix", :string, :limit => 2
    t.column "street_name", :string, :limit => 32
    t.column "street_type", :string, :limit => 4
    t.column "street_suffix", :string, :limit => 2
    t.column "apt_type", :string, :limit => 5
    t.column "apt_no", :string, :limit => 8
    t.column "city", :string, :limit => 32
    t.column "state", :string, :limit => 2
    t.column "zip5", :string, :limit => 5
    t.column "zip4", :string, :limit => 4
    t.column "county_name", :string, :limit => 32
    t.column "precinct_name", :string, :limit => 32
    t.column "precinct_code", :string, :limit => 32
    t.column "cd", :string, :limit => 3
    t.column "sd", :string, :limit => 3
    t.column "hd", :string, :limit => 3
    t.column "comm_dist_code", :string, :limit => 2
    t.column "lat", :decimal, :precision => 15, :scale => 10
    t.column "lng", :decimal, :precision => 15, :scale => 10
    t.column "geo_failed", :boolean
    t.column "address_hash", :string, :limit => 32
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :point, :srid => 4326
    t.column "mcomm_dist_code", :string, :limit => 2
    t.column "is_odd", :boolean
    t.column "street_no_int", :integer
  end

  add_index "addresses", ["address_hash"], :name => "index_addresses_on_address_hash", :unique => true
  add_index "addresses", ["cd"], :name => "index_addresses_on_cd"
  add_index "addresses", ["city"], :name => "index_addresses_on_city"
  add_index "addresses", ["comm_dist_code"], :name => "index_addresses_on_comm_dist_code"
  add_index "addresses", ["county_name"], :name => "index_addresses_on_county_name"
  add_index "addresses", ["geom"], :name => "index_addresses_on_geom", :spatial=> true 
  add_index "addresses", ["hd"], :name => "index_addresses_on_hd"
  add_index "addresses", ["id"], :name => "index_addresses_on_id"
  add_index "addresses", ["is_odd"], :name => "index_addresses_on_is_odd"
  add_index "addresses", ["lat", "lng"], :name => "index_addresses_on_lat_and_lng"
  add_index "addresses", ["precinct_code"], :name => "index_addresses_on_precinct_code"
  add_index "addresses", ["sd"], :name => "index_addresses_on_sd"
  add_index "addresses", ["state"], :name => "index_addresses_on_state"

  create_table "addresses_gis_regions", :id => false, :force => true do |t|
    t.column "address_id", :integer, :null => false
    t.column "gis_region_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "addresses_gis_regions", ["address_id"], :name => "index_addresses_gis_regions_on_address_id"
  add_index "addresses_gis_regions", ["address_id", "gis_region_id"], :name => "index_addresses_gis_regions_on_address_id_and_gis_region_id", :unique => true
  add_index "addresses_gis_regions", ["gis_region_id"], :name => "index_addresses_gis_regions_on_gis_region_id"

  create_table "attachments", :force => true do |t|
    t.column "attachable_id", :integer
    t.column "attachable_type", :string
    t.column "type", :string
    t.column "data_file_name", :string
    t.column "data_content_type", :string
    t.column "data_file_size", :integer
    t.column "data_updated_at", :datetime
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "attachments", ["attachable_id", "attachable_type"], :name => "index_attachments_on_attachable_id_and_attachable_type"
  add_index "attachments", ["attachable_id", "attachable_type", "type"], :name => "index_attachments_on_attachable_id_and_attachable_type_and_type"
  add_index "attachments", ["type"], :name => "index_attachments_on_type"

  create_table "campaign_smsses", :force => true do |t|
    t.column "cell_phone", :string, :limit => 10, :null => false
    t.column "status", :string, :limit => 4
    t.column "campaign_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "campaign_smsses", ["campaign_id"], :name => "index_campaign_smsses_on_campaign_id"
  add_index "campaign_smsses", ["cell_phone", "campaign_id"], :name => "index_campaign_smsses_on_campaign_id_and_cell_phone", :unique => true
  add_index "campaign_smsses", ["status"], :name => "index_campaign_smsses_on_status"

  create_table "campaigns", :force => true do |t|
    t.column "type", :string, :limit => 100, :null => false
    t.column "name", :string, :limit => 100, :null => false
    t.column "scheduled_at", :datetime
    t.column "caller_id", :string, :limit => 10
    t.column "single_sound_file", :boolean
    t.column "scrub_dnc", :boolean
    t.column "sms_text", :text
    t.column "delayed_job_id", :integer
    t.column "contact_list_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "user_name", :string, :limit => 100
    t.column "user_ip_address", :string, :limit => 32
    t.column "acknowledgement", :boolean
    t.column "populated", :boolean
    t.column "voter_count", :integer
  end

  add_index "campaigns", ["contact_list_id"], :name => "index_campaigns_on_contact_list_id"
  add_index "campaigns", ["delayed_job_id"], :name => "index_campaigns_on_delayed_job_id"
  add_index "campaigns", ["id", "type"], :name => "index_campaigns_on_id_and_type"
  add_index "campaigns", ["type", "name"], :name => "index_campaigns_on_type_and_name"

  create_table "carts", :force => true do |t|
    t.column "user_id", :integer
    t.column "purchased_at", :datetime
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "carts", ["user_id"], :name => "index_carts_on_user_id"

  create_table "categories", :force => true do |t|
    t.column "name", :string, :limit => 100
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "categories", ["name"], :name => "index_categories_on_name", :unique => true

  create_table "cities", :force => true do |t|
    t.column "name", :string, :limit => 64, :null => false
    t.column "state_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "lat", :decimal, :precision => 15, :scale => 10
    t.column "lng", :decimal, :precision => 15, :scale => 10
  end

  add_index "cities", ["name"], :name => "index_cities_on_name"
  add_index "cities", ["name", "state_id"], :name => "index_cities_on_name_and_state_id", :unique => true
  add_index "cities", ["state_id"], :name => "index_cities_on_state_id"

  create_table "cities_counties", :id => false, :force => true do |t|
    t.column "city_id", :integer, :null => false
    t.column "county_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "cities_counties", ["city_id"], :name => "index_cities_counties_on_city_id"
  add_index "cities_counties", ["county_id"], :name => "index_cities_counties_on_county_id"

  create_table "cities_municipal_districts", :id => false, :force => true do |t|
    t.column "city_id", :integer, :null => false
    t.column "municipal_district_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "cities_municipal_districts", ["city_id"], :name => "index_cities_municipal_districts_on_city_id"
  add_index "cities_municipal_districts", ["municipal_district_id"], :name => "index_cities_municipal_districts_on_municipal_district_id"

  create_table "city_precincts", :force => true do |t|
    t.column "city_id", :integer
    t.column "precinct_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "city_precincts", ["city_id"], :name => "index_city_precincts_on_city_id"
  add_index "city_precincts", ["city_id", "precinct_id"], :name => "index_city_precincts_on_city_id_and_precinct_id", :unique => true
  add_index "city_precincts", ["precinct_id"], :name => "index_city_precincts_on_precinct_id"

  create_table "congressional_districts", :force => true do |t|
    t.column "cd", :string, :limit => 3, :null => false
    t.column "state_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "congressional_districts", ["cd", "state_id"], :name => "index_congressional_districts_on_state_id_and_cd", :unique => true

  create_table "constituent_addresses", :force => true do |t|
    t.column "political_campaign_id", :integer
    t.column "address_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "constituent_addresses", ["address_id"], :name => "index_constituent_addresses_on_address_id"
  add_index "constituent_addresses", ["political_campaign_id"], :name => "index_constituent_addresses_on_political_campaign_id"

  create_table "constituents", :force => true do |t|
    t.column "political_campaign_id", :integer, :null => false
    t.column "voter_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "constituents", ["political_campaign_id"], :name => "index_constituents_on_political_campaign_id"
  add_index "constituents", ["political_campaign_id", "voter_id"], :name => "index_constituents_on_political_campaign_id_and_voter_id", :unique => true
  add_index "constituents", ["voter_id"], :name => "index_constituents_on_voter_id"

  create_table "contact_list_addresses", :force => true do |t|
    t.column "contact_list_id", :integer
    t.column "address_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "contact_list_addresses", ["address_id"], :name => "index_contact_list_addresses_on_address_id"
  add_index "contact_list_addresses", ["contact_list_id"], :name => "index_contact_list_addresses_on_contact_list_id"
  add_index "contact_list_addresses", ["contact_list_id", "address_id"], :name => "index_contact_list_addresses_on_contact_list_id_and_address_id", :unique => true

  create_table "contact_list_robocalls", :force => true do |t|
    t.column "phone", :string, :limit => 10, :null => false
    t.column "contact_list_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "contact_list_robocalls", ["contact_list_id"], :name => "index_contact_list_robocalls_on_contact_list_id"

  create_table "contact_list_smsses", :force => true do |t|
    t.column "cell_phone", :string, :limit => 10, :null => false
    t.column "contact_list_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "status", :string, :limit => 4
  end

  add_index "contact_list_smsses", ["contact_list_id"], :name => "index_contact_list_smsses_on_contact_list_id"
  add_index "contact_list_smsses", ["status"], :name => "index_contact_list_smsses_on_status"

  create_table "contact_list_voters", :force => true do |t|
    t.column "contact_list_id", :integer
    t.column "voter_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "contact_list_voters", ["contact_list_id"], :name => "index_contact_list_voters_on_contact_list_id"
  add_index "contact_list_voters", ["contact_list_id", "voter_id"], :name => "index_contact_list_voters_on_contact_list_id_and_voter_id", :unique => true
  add_index "contact_list_voters", ["voter_id"], :name => "index_contact_list_voters_on_voter_id"

  create_table "contact_lists", :force => true do |t|
    t.column "name", :string, :limit => 100, :null => false
    t.column "constituent_count", :integer
    t.column "populated", :boolean, :default => false
    t.column "political_campaign_id", :integer, :null => false
    t.column "type", :string, :limit => 100, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "upload_list", :boolean
    t.column "mapped_fields", :text
  end

  add_index "contact_lists", ["name", "type"], :name => "index_contact_lists_on_name_and_type"
  add_index "contact_lists", ["name", "political_campaign_id", "type"], :name => "index_contact_lists_on_political_campaign_id_and_name_and_type", :unique => true

  create_table "council_districts", :force => true do |t|
    t.column "code", :string, :limit => 3, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "council_districts", ["code"], :name => "index_council_districts_on_code", :unique => true

  create_table "council_districts_counties", :id => false, :force => true do |t|
    t.column "county_id", :integer, :null => false
    t.column "council_district_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "council_districts_counties", ["council_district_id"], :name => "index_council_districts_counties_on_council_district_id"
  add_index "council_districts_counties", ["county_id"], :name => "index_council_districts_counties_on_county_id"

  create_table "counties", :force => true do |t|
    t.column "name", :string, :limit => 64, :null => false
    t.column "state_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "lat", :decimal, :precision => 15, :scale => 10
    t.column "lng", :decimal, :precision => 15, :scale => 10
  end

  add_index "counties", ["name"], :name => "index_counties_on_name"
  add_index "counties", ["name", "state_id"], :name => "index_counties_on_state_id_and_name", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.column "priority", :integer, :default => 0
    t.column "attempts", :integer, :default => 0
    t.column "handler", :text
    t.column "last_error", :text
    t.column "run_at", :datetime
    t.column "locked_at", :datetime
    t.column "failed_at", :datetime
    t.column "locked_by", :string
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "elections", :force => true do |t|
    t.column "description", :string, :limit => 32, :null => false
    t.column "year", :integer, :null => false
    t.column "election_type", :string, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "elections", ["description"], :name => "index_elections_on_description", :unique => true
  add_index "elections", ["year", "election_type"], :name => "index_elections_on_year_and_election_type", :unique => true

  create_table "events", :force => true do |t|
    t.column "event_date", :datetime
    t.column "event_code", :string, :limit => 25
    t.column "event_message", :text
    t.column "contact_list_id", :integer
    t.column "address_id", :integer
    t.column "voter_id", :integer
    t.column "eventable_id", :integer
    t.column "eventable_type", :string
    t.column "type", :string, :limit => 64
    t.column "delayed_job_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "events", ["address_id"], :name => "index_events_on_address_id"
  add_index "events", ["contact_list_id"], :name => "index_events_on_contact_list_id"
  add_index "events", ["eventable_id"], :name => "index_events_on_eventable_id"
  add_index "events", ["eventable_type"], :name => "index_events_on_eventable_type"
  add_index "events", ["type"], :name => "index_events_on_type"
  add_index "events", ["voter_id"], :name => "index_events_on_voter_id"

  create_table "filters", :force => true do |t|
    t.column "type", :string, :limit => 64, :null => false
    t.column "string_val", :string, :limit => 64
    t.column "int_val", :integer
    t.column "max_int_val", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "contact_list_id", :integer
  end

  add_index "filters", ["id"], :name => "index_filters_on_id", :unique => true
  add_index "filters", ["type"], :name => "index_filters_on_type"
  add_index "filters", ["type", "contact_list_id"], :name => "index_filters_on_type_and_contact_list_id"

# Could not dump table "geography_columns" because of following StandardError
#   Unknown type 'name' for column 'f_table_catalog' /home/mark/Work/pboost/vendor/gems/postgis_adapter-0.7.8/lib/postgis_adapter/common_spatial_adapter.rb:52:in `table'/home/mark/Work/pboost/vendor/gems/postgis_adapter-0.7.8/lib/postgis_adapter/common_spatial_adapter.rb:50:in `each'/home/mark/Work/pboost/vendor/gems/postgis_adapter-0.7.8/lib/postgis_adapter/common_spatial_adapter.rb:50:in `table'/usr/lib/ruby/gems/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:72:in `tables'/usr/lib/ruby/gems/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:63:in `each'/usr/lib/ruby/gems/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:63:in `tables'/usr/lib/ruby/gems/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:25:in `dump'/usr/lib/ruby/gems/1.8/gems/activerecord-2.3.8/lib/active_record/schema_dumper.rb:19:in `dump'/usr/lib/ruby/gems/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:256/usr/lib/ruby/gems/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:255:in `open'/usr/lib/ruby/gems/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:255/usr/lib/ruby/1.8/rake.rb:636:in `call'/usr/lib/ruby/1.8/rake.rb:636:in `execute'/usr/lib/ruby/1.8/rake.rb:631:in `each'/usr/lib/ruby/1.8/rake.rb:631:in `execute'/usr/lib/ruby/1.8/rake.rb:597:in `invoke_with_call_chain'/usr/lib/ruby/1.8/monitor.rb:242:in `synchronize'/usr/lib/ruby/1.8/rake.rb:590:in `invoke_with_call_chain'/usr/lib/ruby/1.8/rake.rb:583:in `invoke'/usr/lib/ruby/gems/1.8/gems/rails-2.3.8/lib/tasks/databases.rake:113/usr/lib/ruby/1.8/rake.rb:636:in `call'/usr/lib/ruby/1.8/rake.rb:636:in `execute'/usr/lib/ruby/1.8/rake.rb:631:in `each'/usr/lib/ruby/1.8/rake.rb:631:in `execute'/usr/lib/ruby/1.8/rake.rb:597:in `invoke_with_call_chain'/usr/lib/ruby/1.8/monitor.rb:242:in `synchronize'/usr/lib/ruby/1.8/rake.rb:590:in `invoke_with_call_chain'/usr/lib/ruby/1.8/rake.rb:583:in `invoke'/usr/lib/ruby/1.8/rake.rb:2051:in `invoke_task'/usr/lib/ruby/1.8/rake.rb:2029:in `top_level'/usr/lib/ruby/1.8/rake.rb:2029:in `each'/usr/lib/ruby/1.8/rake.rb:2029:in `top_level'/usr/lib/ruby/1.8/rake.rb:2068:in `standard_exception_handling'/usr/lib/ruby/1.8/rake.rb:2023:in `top_level'/usr/lib/ruby/1.8/rake.rb:2001:in `run'/usr/lib/ruby/1.8/rake.rb:2068:in `standard_exception_handling'/usr/lib/ruby/1.8/rake.rb:1998:in `run'/usr/bin/rake:28

  create_table "gis_regions", :force => true do |t|
    t.column "name", :string, :limit => 128, :null => false
    t.column "political_campaign_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "geom", :polygon, :srid => 4326, :null => false
    t.column "voter_count", :integer, :default => 0
    t.column "populated", :boolean, :default => false
    t.column "geom2", :multi_polygon, :srid => 4326
    t.column "contact_list_id", :integer
  end

  add_index "gis_regions", ["contact_list_id"], :name => "index_gis_regions_on_contact_list_id"
  add_index "gis_regions", ["geom"], :name => "index_gis_regions_on_geom", :spatial=> true 
  add_index "gis_regions", ["geom2"], :name => "index_gis_regions_on_geom2", :spatial=> true 
  add_index "gis_regions", ["name", "political_campaign_id"], :name => "index_gis_regions_on_name_and_political_campaign_id", :unique => true
  add_index "gis_regions", ["political_campaign_id"], :name => "index_gis_regions_on_political_campaign_id"

  create_table "gis_regions_voters", :id => false, :force => true do |t|
    t.column "gis_region_id", :integer, :null => false
    t.column "voter_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "gis_regions_voters", ["gis_region_id"], :name => "index_gis_regions_voters_on_gis_region_id"
  add_index "gis_regions_voters", ["gis_region_id", "voter_id"], :name => "index_gis_regions_voters_on_gis_region_id_and_voter_id", :unique => true
  add_index "gis_regions_voters", ["voter_id"], :name => "index_gis_regions_voters_on_voter_id"

  create_table "house_districts", :force => true do |t|
    t.column "hd", :string, :limit => 3, :null => false
    t.column "state_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "house_districts", ["hd", "state_id"], :name => "index_house_districts_on_state_id_and_hd", :unique => true

  create_table "line_item_campaigns", :force => true do |t|
    t.column "line_item_id", :integer, :null => false
    t.column "campaign_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "line_item_campaigns", ["campaign_id"], :name => "index_line_item_campaigns_on_campaign_id"
  add_index "line_item_campaigns", ["line_item_id"], :name => "index_line_item_campaigns_on_line_item_id"
  add_index "line_item_campaigns", ["line_item_id", "campaign_id"], :name => "index_line_item_campaigns_on_line_item_id_and_campaign_id", :unique => true

  create_table "line_item_contact_lists", :force => true do |t|
    t.column "line_item_id", :integer, :null => false
    t.column "contact_list_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "line_item_contact_lists", ["contact_list_id"], :name => "index_line_item_contact_lists_on_contact_list_id"
  add_index "line_item_contact_lists", ["line_item_id"], :name => "index_line_item_contact_lists_on_line_item_id"

  create_table "line_items", :force => true do |t|
    t.column "unit_price", :decimal, :precision => 13, :scale => 4
    t.column "product_id", :integer
    t.column "cart_id", :integer
    t.column "quantity", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "line_items", ["cart_id"], :name => "index_line_items_on_cart_id"
  add_index "line_items", ["product_id"], :name => "index_line_items_on_product_id"

  create_table "municipal_districts", :force => true do |t|
    t.column "code", :string, :limit => 3, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "municipal_districts", ["code"], :name => "index_municipal_districts_on_code", :unique => true

  create_table "order_transactions", :force => true do |t|
    t.column "order_id", :integer
    t.column "action", :string
    t.column "amount", :integer
    t.column "success", :boolean
    t.column "authorization", :string
    t.column "message", :string
    t.column "params", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "order_transactions", ["order_id"], :name => "index_order_transactions_on_order_id"

  create_table "orders", :force => true do |t|
    t.column "cart_id", :integer
    t.column "ip_address", :string, :limit => 50
    t.column "first_name", :string, :limit => 32, :null => false
    t.column "last_name", :string, :limit => 32, :null => false
    t.column "card_type", :string, :limit => 32
    t.column "card_expires_on", :date
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "orders", ["cart_id"], :name => "index_orders_on_cart_id"

  create_table "organization_types", :force => true do |t|
    t.column "name", :string, :limit => 100, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "organization_types", ["name"], :name => "index_organization_types_on_name", :unique => true

  create_table "organizations", :force => true do |t|
    t.column "organization_type_id", :integer
    t.column "name", :string, :limit => 100, :null => false
    t.column "email", :string, :limit => 125
    t.column "phone", :string, :limit => 10
    t.column "fax", :string, :limit => 10
    t.column "website", :string, :limit => 150
    t.column "enabled", :boolean, :default => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "account_type_id", :integer
  end

  add_index "organizations", ["email"], :name => "index_organizations_on_email", :unique => true

  create_table "parties", :force => true do |t|
    t.column "code", :string, :limit => 1, :null => false
    t.column "name", :string, :limit => 32, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "parties", ["code"], :name => "index_parties_on_code", :unique => true
  add_index "parties", ["name"], :name => "index_parties_on_name", :unique => true

  create_table "political_campaigns", :force => true do |t|
    t.column "candidate_name", :string, :limit => 64
    t.column "seat_sought", :string, :limit => 128
    t.column "state_id", :integer, :null => false
    t.column "type", :string, :limit => 20
    t.column "seat_type", :string, :limit => 20
    t.column "congressional_district_id", :integer
    t.column "senate_district_id", :integer
    t.column "house_district_id", :integer
    t.column "county_id", :integer
    t.column "countywide", :boolean, :null => false
    t.column "council_district_id", :integer
    t.column "city_id", :integer
    t.column "muniwide", :boolean, :null => false
    t.column "organization_id", :integer
    t.column "municipal_district_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "constituent_count", :integer, :default => 0
    t.column "populated", :boolean, :default => false
  end

  add_index "political_campaigns", ["city_id"], :name => "index_political_campaigns_on_city_id"
  add_index "political_campaigns", ["congressional_district_id"], :name => "index_political_campaigns_on_congressional_district_id"
  add_index "political_campaigns", ["council_district_id"], :name => "index_political_campaigns_on_council_district_id"
  add_index "political_campaigns", ["county_id"], :name => "index_political_campaigns_on_county_id"
  add_index "political_campaigns", ["house_district_id"], :name => "index_political_campaigns_on_house_district_id"
  add_index "political_campaigns", ["municipal_district_id"], :name => "index_political_campaigns_on_municipal_district_id"
  add_index "political_campaigns", ["organization_id"], :name => "index_political_campaigns_on_organization_id"
  add_index "political_campaigns", ["senate_district_id"], :name => "index_political_campaigns_on_senate_district_id"

  create_table "precincts", :force => true do |t|
    t.column "name", :string, :limit => 32, :null => false
    t.column "code", :string, :limit => 32, :null => false
    t.column "county_id", :integer
    t.column "congressional_district_id", :integer
    t.column "senate_district_id", :integer
    t.column "house_district_id", :integer
    t.column "council_district_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "state_id", :integer
    t.column "municipal_district_id", :integer
  end

  add_index "precincts", ["code"], :name => "index_precincts_on_code"
  add_index "precincts", ["code", "congressional_district_id"], :name => "index_precincts_on_code_and_congressional_district_id", :unique => true
  add_index "precincts", ["code", "council_district_id"], :name => "index_precincts_on_code_and_council_district_id", :unique => true
  add_index "precincts", ["county_id", "code"], :name => "index_precincts_on_code_and_county_id", :unique => true
  add_index "precincts", ["house_district_id", "code"], :name => "index_precincts_on_code_and_house_district_id", :unique => true
  add_index "precincts", ["code", "senate_district_id"], :name => "index_precincts_on_code_and_senate_district_id", :unique => true
  add_index "precincts", ["congressional_district_id"], :name => "index_precincts_on_congressional_district_id"
  add_index "precincts", ["council_district_id"], :name => "index_precincts_on_council_district_id"
  add_index "precincts", ["county_id"], :name => "index_precincts_on_county_id"
  add_index "precincts", ["house_district_id"], :name => "index_precincts_on_house_district_id"
  add_index "precincts", ["municipal_district_id"], :name => "index_precincts_on_municipal_district_id"
  add_index "precincts", ["code", "municipal_district_id"], :name => "index_precincts_on_municipal_district_id_and_code", :unique => true
  add_index "precincts", ["name"], :name => "index_precincts_on_name"
  add_index "precincts", ["code", "name"], :name => "index_precincts_on_name_and_code", :unique => true
  add_index "precincts", ["senate_district_id"], :name => "index_precincts_on_senate_district_id"
  add_index "precincts", ["state_id"], :name => "index_precincts_on_state_id"

  create_table "products", :force => true do |t|
    t.column "category_id", :integer
    t.column "name", :string, :limit => 100
    t.column "price", :decimal, :precision => 13, :scale => 4
    t.column "description", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "products", ["category_id"], :name => "index_products_on_category_id"
  add_index "products", ["name"], :name => "index_products_on_name", :unique => true

  create_table "roles", :force => true do |t|
    t.column "name", :string, :limit => 50
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.column "role_id", :integer, :null => false
    t.column "user_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "senate_districts", :force => true do |t|
    t.column "sd", :string, :limit => 3, :null => false
    t.column "state_id", :integer, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "senate_districts", ["sd", "state_id"], :name => "index_senate_districts_on_state_id_and_sd", :unique => true

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string, :null => false
    t.column "data", :text
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "states", :force => true do |t|
    t.column "abbrev", :string, :limit => 2, :null => false
    t.column "name", :string, :limit => 100, :null => false
    t.column "active", :boolean, :default => true
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
    t.column "lat", :decimal, :precision => 15, :scale => 10
    t.column "lng", :decimal, :precision => 15, :scale => 10
  end

  add_index "states", ["abbrev"], :name => "index_states_on_abbrev", :unique => true
  add_index "states", ["name"], :name => "index_states_on_name", :unique => true

  create_table "survey_answers", :force => true do |t|
    t.column "survey_question_id", :integer
    t.column "answer_key", :string, :limit => 1, :null => false
    t.column "answer_text", :text, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "survey_answers", ["survey_question_id"], :name => "index_survey_answers_on_survey_question_id"
  add_index "survey_answers", ["survey_question_id", "answer_key"], :name => "index_survey_answers_on_survey_question_id_and_answer_key", :unique => true
  add_index "survey_answers", ["survey_question_id", "answer_text"], :name => "index_survey_answers_on_survey_question_id_and_answer_text", :unique => true

  create_table "survey_questions", :force => true do |t|
    t.column "question_text", :text, :null => false
    t.column "contact_list_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "survey_questions", ["contact_list_id"], :name => "index_survey_questions_on_contact_list_id"

  create_table "time_zones", :force => true do |t|
    t.column "zone", :string, :limit => 64, :null => false
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "time_zones", ["zone"], :name => "index_time_zones_on_zone", :unique => true

  create_table "users", :force => true do |t|
    t.column "login", :string, :limit => 100, :null => false
    t.column "email", :string, :limit => 100, :null => false
    t.column "first_name", :string, :limit => 32, :null => false
    t.column "last_name", :string, :limit => 32, :null => false
    t.column "phone", :string, :limit => 10
    t.column "crypted_password", :string
    t.column "password_salt", :string
    t.column "persistence_token", :string, :null => false
    t.column "perishable_token", :string, :null => false
    t.column "active", :boolean, :default => false, :null => false
    t.column "login_count", :integer, :default => 0, :null => false
    t.column "failed_login_count", :integer, :default => 0, :null => false
    t.column "last_request_at", :datetime
    t.column "current_login_at", :datetime
    t.column "last_login_at", :datetime
    t.column "current_login_ip", :string
    t.column "last_login_ip", :string
    t.column "time_zone_id", :integer
    t.column "organization_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["organization_id"], :name => "index_users_on_organization_id"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token", :unique => true

  create_table "voters", :force => true do |t|
    t.column "vote_builder_id", :integer, :limit => 8
    t.column "last_name", :string, :limit => 32
    t.column "first_name", :string, :limit => 32
    t.column "middle_name", :string, :limit => 32
    t.column "suffix", :string, :limit => 4
    t.column "salutation", :string, :limit => 32
    t.column "phone", :string, :limit => 10
    t.column "home_phone", :string, :limit => 10
    t.column "work_phone", :string, :limit => 10
    t.column "work_phone_ext", :string, :limit => 10
    t.column "cell_phone", :string, :limit => 10
    t.column "email", :string, :limit => 50
    t.column "party", :string, :limit => 1
    t.column "sex", :string, :limit => 1
    t.column "age", :integer, :limit => 2
    t.column "dob", :date
    t.column "dor", :date
    t.column "state_file_id", :string, :limit => 10
    t.column "address_id", :integer
    t.column "search_index", :string, :limit => 13
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "voters", ["address_id"], :name => "index_voters_on_address_id"
  add_index "voters", ["age"], :name => "index_voters_on_age"
  add_index "voters", ["id"], :name => "index_voters_on_id"
  add_index "voters", ["party"], :name => "index_voters_on_party"
  add_index "voters", ["search_index"], :name => "index_voters_on_search_index"
  add_index "voters", ["sex"], :name => "index_voters_on_sex"
  add_index "voters", ["vote_builder_id"], :name => "index_voters_on_vote_builder_id", :unique => true

  create_table "voting_history_voters", :force => true do |t|
    t.column "election_year", :integer
    t.column "election_month", :integer
    t.column "election_type", :string, :limit => 2
    t.column "voter_type", :string, :limit => 1
    t.column "voter_id", :integer
    t.column "created_at", :datetime
    t.column "updated_at", :datetime
  end

  add_index "voting_history_voters", ["voter_id"], :name => "index_voting_history_voters_on_voter_id"

end
