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

ActiveRecord::Schema.define(:version => 3) do

  create_table "jobs", :force => true do |t|
    t.string   "status",                              :default => "Pending"
    t.text     "stdout",        :limit => 2147483647
    t.text     "stderr",        :limit => 2147483647
    t.string   "revision"
    t.string   "msg"
    t.integer  "smoke_test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "smoke_tests", :force => true do |t|
    t.string   "branch_url"
    t.string   "description"
    t.string   "last_revision"
    t.string   "status",        :default => "Pending"
    t.boolean  "merge_trunk",   :default => true
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
