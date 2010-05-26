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

ActiveRecord::Schema.define(:version => 20100525223449) do

  create_table "account_types", :force => true do |t|
    t.string   "name",       :limit => 100, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_types", ["name"], :name => "index_account_types_on_name", :unique => true

  create_table "organization_types", :force => true do |t|
    t.string   "name",       :limit => 100, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organization_types", ["name"], :name => "index_organization_types_on_name", :unique => true

  create_table "organizations", :force => true do |t|
    t.integer  "organization_type_id"
    t.string   "name",                 :limit => 100,                    :null => false
    t.string   "email",                :limit => 125
    t.string   "phone",                :limit => 10
    t.string   "fax",                  :limit => 10
    t.string   "website",              :limit => 150
    t.integer  "account_type_id"
    t.boolean  "enabled",                             :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name",       :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name"], :name => "index_roles_on_name", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "time_zones", :force => true do |t|
    t.string   "zone",       :limit => 64, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "time_zones", ["zone"], :name => "index_time_zones_on_zone", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",              :limit => 100,                    :null => false
    t.string   "email",              :limit => 100,                    :null => false
    t.string   "first_name",         :limit => 32,                     :null => false
    t.string   "last_name",          :limit => 32,                     :null => false
    t.string   "phone",              :limit => 10
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                                    :null => false
    t.string   "perishable_token",                                     :null => false
    t.boolean  "active",                            :default => false, :null => false
    t.integer  "login_count",                       :default => 0,     :null => false
    t.integer  "failed_login_count",                :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "time_zone_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["organization_id"], :name => "index_users_on_organization_id"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token", :unique => true

end
