# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160208013549) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "addresses", force: true do |t|
    t.string   "street_no",             limit: 10
    t.string   "street_no_half",        limit: 10
    t.string   "street_prefix",         limit: 10
    t.string   "street_name",           limit: 50
    t.string   "street_type",           limit: 10
    t.string   "street_suffix",         limit: 10
    t.string   "apt_type",              limit: 10
    t.string   "apt_no",                limit: 20
    t.string   "city",                  limit: 32
    t.string   "state",                 limit: 2
    t.string   "zip5",                  limit: 5
    t.string   "zip4",                  limit: 4
    t.string   "county_name",           limit: 32
    t.string   "precinct_name",         limit: 32
    t.string   "precinct_code",         limit: 32
    t.string   "cd",                    limit: 3
    t.string   "sd",                    limit: 3
    t.string   "hd",                    limit: 3
    t.string   "comm_dist_code",        limit: 3
    t.decimal  "lat",                                                                            precision: 15, scale: 10
    t.decimal  "lng",                                                                            precision: 15, scale: 10
    t.boolean  "geo_failed"
    t.string   "address_hash",          limit: 32
    t.boolean  "is_odd"
    t.integer  "street_no_int"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ward_district",         limit: 10
    t.string   "municipal_district",    limit: 10
    t.string   "commissioner_district", limit: 10
    t.string   "school_district",       limit: 10
    t.spatial  "geom",                  limit: {:srid=>4326, :type=>"point", :geographic=>true}
  end

  add_index "addresses", ["address_hash"], :name => "index_addresses_on_address_hash", :unique => true
  add_index "addresses", ["cd"], :name => "index_addresses_on_cd"
  add_index "addresses", ["city"], :name => "index_addresses_on_city"
  add_index "addresses", ["comm_dist_code"], :name => "index_addresses_on_comm_dist_code"
  add_index "addresses", ["commissioner_district"], :name => "index_addresses_on_commissioner_district"
  add_index "addresses", ["county_name"], :name => "index_addresses_on_county_name"
  add_index "addresses", ["geom"], :name => "index_addresses_on_geom", :spatial => true
  add_index "addresses", ["hd"], :name => "index_addresses_on_hd"
  add_index "addresses", ["id"], :name => "index_addresses_on_id"
  add_index "addresses", ["is_odd"], :name => "index_addresses_on_is_odd"
  add_index "addresses", ["lat", "lng"], :name => "index_addresses_on_lat_and_lng"
  add_index "addresses", ["municipal_district"], :name => "index_addresses_on_municipal_district"
  add_index "addresses", ["precinct_code"], :name => "index_addresses_on_precinct_code"
  add_index "addresses", ["school_district"], :name => "index_addresses_on_school_district"
  add_index "addresses", ["sd"], :name => "index_addresses_on_sd"
  add_index "addresses", ["state"], :name => "index_addresses_on_state"
  add_index "addresses", ["street_name"], :name => "index_addresses_on_street_name"
  add_index "addresses", ["ward_district"], :name => "index_addresses_on_ward_district"

  create_table "attachments", force: true do |t|
    t.string   "type",            null: false
    t.string   "attachable_type", null: false
    t.integer  "attachable_id",   null: false
    t.string   "mime_type",       null: false
    t.string   "origin_url",      null: false
    t.string   "description",     null: false
    t.string   "attached_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["attachable_type", "attachable_id"], :name => "idx_attachable_type_and_id"
  add_index "attachments", ["type"], :name => "index_attachments_on_type"

  create_table "circulators", force: true do |t|
    t.string   "first_name",   limit: 32
    t.string   "last_name",    limit: 32
    t.string   "name",         limit: 65,  null: false
    t.string   "address",      limit: 100, null: false
    t.string   "city",         limit: 32,  null: false
    t.string   "state",        limit: 2,   null: false
    t.string   "zip",          limit: 5,   null: false
    t.string   "phone_number", limit: 10,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_job_results", force: true do |t|
    t.integer  "job_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_job_results", ["job_id"], :name => "index_delayed_job_results_on_job_id", :unique => true

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "petition_headers", force: true do |t|
    t.string   "voters_of",           default: ""
    t.boolean  "baltimore_city",      default: false
    t.string   "party_affiliation",   default: ""
    t.boolean  "unaffiliated",        default: false
    t.string   "name",                default: ""
    t.string   "address",             default: ""
    t.string   "office_and_district", default: ""
    t.string   "ltgov_name",          default: ""
    t.string   "ltgov_address",       default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "petition_headers_circulators", id: false, force: true do |t|
    t.integer "petition_header_id"
    t.integer "circulator_id"
  end

  add_index "petition_headers_circulators", ["circulator_id"], :name => "index_petition_headers_circulators_on_circulator_id"
  add_index "petition_headers_circulators", ["petition_header_id", "circulator_id"], :name => "uniq_pet_head_idx", :unique => true
  add_index "petition_headers_circulators", ["petition_header_id"], :name => "index_petition_headers_circulators_on_petition_header_id"

  create_table "petition_headers_users", id: false, force: true do |t|
    t.integer "petition_header_id"
    t.integer "user_id"
  end

  add_index "petition_headers_users", ["petition_header_id", "user_id"], :name => "uniq_pet_head_users_idx", :unique => true
  add_index "petition_headers_users", ["petition_header_id"], :name => "index_petition_headers_users_on_petition_header_id"
  add_index "petition_headers_users", ["user_id"], :name => "index_petition_headers_users_on_user_id"

  create_table "registered_voter_histories", force: true do |t|
    t.integer  "vtrid",                 null: false
    t.string   "election_date"
    t.string   "election_description"
    t.string   "election_type"
    t.string   "political_party"
    t.string   "election_code"
    t.string   "voting_method"
    t.string   "date_of_voting"
    t.string   "precinct"
    t.string   "early_voting_location"
    t.string   "juristiction_code"
    t.string   "county_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registered_voters_data", primary_key: "vtrid", force: true do |t|
    t.string "lastname"
    t.string "firstname"
    t.string "middlename"
    t.string "suffix"
    t.string "dob"
    t.string "gender"
    t.string "party"
    t.string "house_number"
    t.string "house_suffix"
    t.string "street_predirection"
    t.string "streetname"
    t.string "streettype"
    t.string "street_postdirection"
    t.string "unittype"
    t.string "unitnumber"
    t.string "address"
    t.string "non_std_address"
    t.string "residentialcity"
    t.string "residentialstate"
    t.string "residentialzip5"
    t.string "residentialzip4"
    t.string "mailingaddress"
    t.string "mailingcity"
    t.string "mailingstate"
    t.string "mailingzip5"
    t.string "mailingzip4"
    t.string "country"
    t.string "status_code"
    t.string "state_registration_date"
    t.string "county_registration_date"
    t.string "precinct"
    t.string "split"
    t.string "county"
    t.string "congressional_districts"
    t.string "legislative_districts"
    t.string "councilmanic_districts"
    t.string "ward_districts"
    t.string "municipal_districts"
    t.string "commissioner_districts"
    t.string "school_districts"
    t.string "address_hash",             limit: 32
  end

  create_table "registered_voters_history_updates", force: true do |t|
    t.integer  "state_file_id"
    t.string   "voter_type"
    t.integer  "election_year"
    t.integer  "election_month"
    t.string   "election_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registered_voters_history_updates", ["state_file_id"], :name => "index_registered_voters_history_updates_on_state_file_id"

  create_table "roles", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "states", force: true do |t|
    t.string   "abbrev",     limit: 2,                                            null: false
    t.string   "name",       limit: 100,                                          null: false
    t.boolean  "active",                                           default: true, null: false
    t.decimal  "lat",                    precision: 15, scale: 10
    t.decimal  "lng",                    precision: 15, scale: 10
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "states", ["abbrev"], :name => "index_states_on_abbrev", :unique => true
  add_index "states", ["name"], :name => "index_states_on_name", :unique => true

  create_table "users", force: true do |t|
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "users_roles", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "role_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "users_id"
    t.integer  "roles_id"
  end

  add_index "users_roles", ["roles_id"], :name => "index_users_roles_on_roles_id"
  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id", :unique => true
  add_index "users_roles", ["users_id"], :name => "index_users_roles_on_users_id"

  create_table "van_data", id: false, force: true do |t|
    t.integer "vote_builder_id",            null: false
    t.string  "last_name"
    t.string  "first_name"
    t.string  "middle_name"
    t.string  "suffix"
    t.string  "salutation"
    t.string  "street_no"
    t.string  "street_no_half"
    t.string  "street_prefix"
    t.string  "street_name"
    t.string  "street_type"
    t.string  "street_suffix"
    t.string  "apt_type"
    t.string  "apt_no"
    t.string  "city"
    t.string  "state"
    t.string  "zip5"
    t.string  "zip4"
    t.string  "m_address"
    t.string  "m_city"
    t.string  "m_state"
    t.string  "m_zip5"
    t.string  "m_zip4"
    t.string  "phone"
    t.string  "home_phone"
    t.string  "work_phone"
    t.string  "work_phone_ext"
    t.string  "cell_phone"
    t.string  "email"
    t.string  "county_name"
    t.string  "precinct_name"
    t.string  "precinct_code"
    t.string  "cd"
    t.string  "sd"
    t.string  "hd"
    t.string  "comm_dist_code"
    t.string  "party"
    t.string  "sex"
    t.string  "age"
    t.string  "dob"
    t.string  "dor"
    t.string  "general_08"
    t.string  "general_06"
    t.string  "general_04"
    t.string  "general02"
    t.string  "general_00"
    t.string  "general_98"
    t.string  "general_96"
    t.string  "general_94"
    t.string  "muni_general_07"
    t.string  "muni_general_05"
    t.string  "muni_general_03"
    t.string  "muni_general_02"
    t.string  "muni_general_01"
    t.string  "muni_general_00"
    t.string  "muni_primary_07"
    t.string  "muni_primary_05"
    t.string  "muni_primary_03"
    t.string  "muni_primary_01"
    t.string  "muni_primary_99"
    t.string  "primary_08"
    t.string  "primary_06"
    t.string  "primary_04"
    t.string  "primary_02"
    t.string  "primary_00"
    t.string  "primary_98"
    t.string  "primary_96"
    t.string  "primary_94"
    t.integer "state_file_id",              null: false
    t.string  "address_hash",    limit: 32
  end

  add_index "van_data", ["state_file_id"], :name => "index_van_data_on_state_file_id"
  add_index "van_data", ["vote_builder_id"], :name => "index_van_data_on_vote_builder_id"

  create_table "verifications", force: true do |t|
    t.string   "impfile"
    t.string   "expfile"
    t.string   "status",     limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "verifications", ["user_id"], :name => "index_verifications_on_user_id"

  create_table "voters", force: true do |t|
    t.integer  "vote_builder_id",                        limit: 8
    t.string   "last_name",                              limit: 32
    t.string   "first_name",                             limit: 32
    t.string   "middle_name",                            limit: 32
    t.string   "suffix",                                 limit: 30
    t.string   "salutation",                             limit: 32
    t.string   "phone",                                  limit: 10
    t.string   "home_phone",                             limit: 10
    t.string   "work_phone",                             limit: 10
    t.string   "work_phone_ext",                         limit: 10
    t.string   "cell_phone",                             limit: 10
    t.string   "email",                                  limit: 100
    t.string   "party",                                  limit: 5
    t.string   "sex",                                    limit: 1
    t.integer  "age",                                    limit: 2
    t.date     "dob"
    t.date     "dor"
    t.integer  "state_file_id",                                                  null: false
    t.string   "search_index",                           limit: 13
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "address_id"
    t.string   "search_index2",                          limit: 12
    t.integer  "yor"
    t.integer  "presidential_primary_voting_frequency",              default: 0
    t.integer  "presidential_general_voting_frequency",              default: 0
    t.integer  "gubernatorial_primary_voting_frequency",             default: 0
    t.integer  "gubernatorial_general_voting_frequency",             default: 0
    t.integer  "municipal_primary_voting_frequency",                 default: 0
    t.integer  "municipal_general_voting_frequency",                 default: 0
  end

  add_index "voters", ["address_id"], :name => "index_voters_on_address_id"
  add_index "voters", ["age"], :name => "index_voters_on_age"
  add_index "voters", ["id"], :name => "index_voters_on_id"
  add_index "voters", ["party"], :name => "index_voters_on_party"
  add_index "voters", ["search_index"], :name => "index_voters_on_search_index"
  add_index "voters", ["search_index2"], :name => "index_voters_on_search_index2"
  add_index "voters", ["sex"], :name => "index_voters_on_sex"
  add_index "voters", ["state_file_id"], :name => "index_voters_on_state_file_id", :unique => true
  add_index "voters", ["vote_builder_id"], :name => "index_voters_on_vote_builder_id", :unique => true

  create_table "voting_histories", force: true do |t|
    t.integer  "election_year"
    t.integer  "election_month"
    t.string   "election_type",  limit: 2
    t.string   "voter_type",     limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state_file_id",            null: false
  end

  add_index "voting_histories", ["election_type"], :name => "index_voting_histories_on_election_type"
  add_index "voting_histories", ["election_year"], :name => "index_voting_histories_on_election_year"
  add_index "voting_histories", ["state_file_id", "election_type", "election_year"], :name => "uniq_voting_histories_idx", :unique => true
  add_index "voting_histories", ["state_file_id"], :name => "index_voting_histories_on_state_file_id"

end
