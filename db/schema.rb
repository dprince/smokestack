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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 41) do

  create_table "config_modules", :force => true do |t|
    t.string   "type",          :default => "NovaConfigModule", :null => false
    t.string   "url",                                           :null => false
    t.string   "branch"
    t.boolean  "merge_trunk",   :default => true,               :null => false
    t.integer  "smoke_test_id",                                 :null => false
    t.string   "revision_hash", :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "config_modules", ["smoke_test_id"], :name => "index_config_modules_on_smoke_test_id"
  add_index "config_modules", ["type", "smoke_test_id"], :name => "index_config_modules_on_type_and_smoke_test_id"
  add_index "config_modules", ["type"], :name => "index_config_modules_on_type"

  create_table "config_templates", :force => true do |t|
    t.string   "name",                                :null => false
    t.string   "description",                         :null => false
    t.string   "cookbook_repo_url",                   :null => false
    t.text     "server_group_json",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "job_type",          :default => ""
    t.boolean  "enabled",           :default => true
    t.text     "environment"
  end

  create_table "config_templates_smoke_tests", :id => false, :force => true do |t|
    t.integer "config_template_id", :null => false
    t.integer "smoke_test_id",      :null => false
  end

  create_table "job_groups", :force => true do |t|
    t.string   "status",        :default => "Pending", :null => false
    t.integer  "smoke_test_id",                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "jobs", :force => true do |t|
    t.string   "status",                                              :default => "Pending"
    t.text     "stdout",                        :limit => 2147483647
    t.text     "stderr",                        :limit => 2147483647
    t.string   "nova_revision"
    t.string   "msg"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "glance_revision"
    t.integer  "job_group_id",                                                               :null => false
    t.integer  "config_template_id"
    t.string   "type",                                                :default => ""
    t.string   "keystone_revision"
    t.integer  "approved_by"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.string   "swift_revision"
    t.string   "cinder_revision"
    t.string   "neutron_revision"
    t.string   "nova_conf_module_revision"
    t.string   "keystone_conf_module_revision"
    t.string   "glance_conf_module_revision"
    t.string   "swift_conf_module_revision"
    t.string   "cinder_conf_module_revision"
    t.string   "neutron_conf_module_revision"
  end

  create_table "node_configs", :force => true do |t|
    t.integer  "config_template_id", :null => false
    t.string   "hostname",           :null => false
    t.text     "config_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "package_builders", :force => true do |t|
    t.string   "type",            :default => "NovaPackageBuilder", :null => false
    t.string   "url",                                               :null => false
    t.string   "branch"
    t.boolean  "merge_trunk",     :default => true,                 :null => false
    t.integer  "smoke_test_id",                                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "revision_hash",   :default => ""
    t.string   "packager_url",    :default => ""
    t.string   "packager_branch", :default => ""
  end

  add_index "package_builders", ["smoke_test_id"], :name => "index_package_builders_on_smoke_test_id"
  add_index "package_builders", ["type", "smoke_test_id"], :name => "index_package_builders_on_type_and_smoke_test_id"
  add_index "package_builders", ["type"], :name => "index_package_builders_on_type"

  create_table "smoke_tests", :force => true do |t|
    t.string   "description"
    t.string   "status",       :default => "Pending"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "unit_tests",   :default => false
    t.string   "cookbook_url"
    t.string   "project"
  end

  add_index "smoke_tests", ["project"], :name => "index_smoke_tests_on_project"

  create_table "smoke_tests_test_suites", :id => false, :force => true do |t|
    t.integer "smoke_test_id", :null => false
    t.integer "test_suite_id", :null => false
  end

  create_table "test_suites", :force => true do |t|
    t.string   "description",                   :null => false
    t.string   "name",                          :null => false
    t.boolean  "enabled",     :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                           :null => false
    t.string   "first_name",                         :null => false
    t.string   "last_name",                          :null => false
    t.string   "hashed_password",                    :null => false
    t.string   "salt",                               :null => false
    t.boolean  "is_active",       :default => true,  :null => false
    t.boolean  "is_admin",        :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
