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

ActiveRecord::Schema.define(:version => 20111218173737) do

  create_table "assets", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.string   "title"
    t.integer  "asseted_id"
    t.string   "asseted_type"
    t.string   "file_name"
    t.string   "file_size"
    t.string   "content_type"
    t.binary   "binary_data",  :limit => 2147483647
    t.boolean  "active"
    t.boolean  "public"
    t.binary   "options",      :limit => 2147483647
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "assets", ["active"], :name => "index_assets_on_active"
  add_index "assets", ["asseted_type", "asseted_id"], :name => "index_assets_on_asseted_type_and_asseted_id"
  add_index "assets", ["content_type"], :name => "index_assets_on_content_type"
  add_index "assets", ["created_at"], :name => "index_assets_on_created_at"
  add_index "assets", ["deleted_at"], :name => "index_assets_on_deleted_at"
  add_index "assets", ["file_name"], :name => "index_assets_on_file_name"
  add_index "assets", ["file_size"], :name => "index_assets_on_file_size"
  add_index "assets", ["public"], :name => "index_assets_on_public"
  add_index "assets", ["title"], :name => "index_assets_on_title"
  add_index "assets", ["token"], :name => "index_assets_on_token"
  add_index "assets", ["type"], :name => "index_assets_on_type"
  add_index "assets", ["updated_at"], :name => "index_assets_on_updated_at"
  add_index "assets", ["user_id"], :name => "index_assets_on_user_id"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 100,        :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.string   "token"
    t.binary   "options",          :limit => 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["commentable_type"], :name => "index_comments_on_commentable_type"
  add_index "comments", ["token"], :name => "index_comments_on_token"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "dynamic_attribute_definitions", :force => true do |t|
    t.text    "definition"
    t.string  "attribute_defineable_type", :null => false
    t.integer "attribute_defineable_id",   :null => false
  end

  add_index "dynamic_attribute_definitions", ["attribute_defineable_id"], :name => "index_dynamic_attribute_definitions_on_attribute_defineable_id"
  add_index "dynamic_attribute_definitions", ["attribute_defineable_type"], :name => "index_dynamic_attribute_definitions_on_attribute_defineable_type"

  create_table "dynamic_attributes", :force => true do |t|
    t.string  "name"
    t.string  "attr_key",          :null => false
    t.string  "object_type",       :null => false
    t.string  "attributable_type", :null => false
    t.integer "attributable_id",   :null => false
    t.integer "integer_value"
    t.string  "string_value"
    t.boolean "boolean_value"
    t.text    "text_value"
    t.float   "float_value"
  end

  add_index "dynamic_attributes", ["attr_key"], :name => "index_dynamic_attributes_on_attr_key"
  add_index "dynamic_attributes", ["attributable_id"], :name => "index_dynamic_attributes_on_attributable_id"
  add_index "dynamic_attributes", ["attributable_type"], :name => "index_dynamic_attributes_on_attributable_type"

  create_table "interactions", :force => true do |t|
    t.string   "type",             :limit => 20
    t.integer  "subjectable_id"
    t.string   "subjectable_type"
    t.integer  "objectable_id"
    t.string   "objectable_type"
    t.integer  "thingable_id"
    t.string   "thingable_type"
    t.boolean  "s_active",                               :default => true
    t.boolean  "o_active",                               :default => false
    t.string   "token"
    t.string   "email"
    t.integer  "user_id"
    t.binary   "options",          :limit => 2147483647
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interactions", ["created_at"], :name => "index_interactions_on_created_at"
  add_index "interactions", ["deleted_at"], :name => "index_interactions_on_deleted_at"
  add_index "interactions", ["email"], :name => "index_interactions_on_email"
  add_index "interactions", ["o_active"], :name => "index_interactions_on_o_active"
  add_index "interactions", ["objectable_id"], :name => "index_interactions_on_objectable_id"
  add_index "interactions", ["objectable_type", "objectable_id"], :name => "index_interactions_on_objectable_type_and_objectable_id"
  add_index "interactions", ["objectable_type"], :name => "index_interactions_on_objectable_type"
  add_index "interactions", ["s_active"], :name => "index_interactions_on_s_active"
  add_index "interactions", ["subjectable_id"], :name => "index_interactions_on_subjectable_id"
  add_index "interactions", ["subjectable_type", "subjectable_id"], :name => "index_interactions_on_subjectable_type_and_subjectable_id"
  add_index "interactions", ["subjectable_type"], :name => "index_interactions_on_subjectable_type"
  add_index "interactions", ["thingable_id"], :name => "index_interactions_on_thingable_id"
  add_index "interactions", ["thingable_type", "thingable_id"], :name => "index_interactions_on_thingable_type_and_thingable_id"
  add_index "interactions", ["thingable_type"], :name => "index_interactions_on_thingable_type"
  add_index "interactions", ["token"], :name => "index_interactions_on_token", :unique => true
  add_index "interactions", ["type"], :name => "index_interactions_on_type"
  add_index "interactions", ["updated_at"], :name => "index_interactions_on_updated_at"
  add_index "interactions", ["user_id"], :name => "index_interactions_on_user_id"

  create_table "posts", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "tree_id"
    t.string   "tree_type"
    t.string   "subject"
    t.text     "body"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "options"
    t.string   "token"
  end

  add_index "posts", ["created_at"], :name => "index_posts_on_created_at"
  add_index "posts", ["deleted_at"], :name => "index_posts_on_deleted_at"
  add_index "posts", ["subject"], :name => "index_posts_on_subject"
  add_index "posts", ["token"], :name => "index_posts_on_token"
  add_index "posts", ["type"], :name => "index_posts_on_type"
  add_index "posts", ["updated_at"], :name => "index_posts_on_updated_at"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "trees", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "options"
    t.string   "token"
  end

  add_index "trees", ["created_at"], :name => "index_trees_on_created_at"
  add_index "trees", ["deleted_at"], :name => "index_trees_on_deleted_at"
  add_index "trees", ["lft"], :name => "index_trees_on_lft"
  add_index "trees", ["name"], :name => "index_trees_on_name"
  add_index "trees", ["parent_id"], :name => "index_trees_on_parent_id"
  add_index "trees", ["rgt"], :name => "index_trees_on_rgt"
  add_index "trees", ["token"], :name => "index_trees_on_token"
  add_index "trees", ["type"], :name => "index_trees_on_type"
  add_index "trees", ["updated_at"], :name => "index_trees_on_updated_at"
  add_index "trees", ["user_id"], :name => "index_trees_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                   :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128,   :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                           :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",                         :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.string   "settings",               :limit => 10000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.binary   "options"
    t.string   "token"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["token"], :name => "index_users_on_token"
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end

