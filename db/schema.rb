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

ActiveRecord::Schema.define(:version => 20120608144908) do

  create_table "photos", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "thumb_width"
    t.integer  "large_width"
    t.string   "original_message_id"
    t.integer  "thumb_height"
    t.integer  "large_height"
    t.integer  "user_id"
  end

  create_table "photos_tags", :force => true do |t|
    t.integer "photo_id"
    t.integer "tag_id"
  end

  add_index "photos_tags", ["photo_id"], :name => "index_photos_tags_on_photo_id"
  add_index "photos_tags", ["tag_id"], :name => "index_photos_tags_on_tag_id"

  create_table "sender_emails", :force => true do |t|
    t.integer "user_id"
    t.string  "address"
  end

  add_index "sender_emails", ["user_id"], :name => "index_sender_emails_on_user_id"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "users", :force => true do |t|
    t.string  "email",      :null => false
    t.boolean "authorized"
    t.boolean "admin"
    t.string  "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end
