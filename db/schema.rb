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

ActiveRecord::Schema.define(version: 20181212170901) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "url",         limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banners", force: :cascade do |t|
    t.boolean  "visible"
    t.string   "heading",      limit: 255
    t.text     "intro_text"
    t.string   "col1_heading", limit: 255
    t.text     "col1_body"
    t.string   "col2_heading", limit: 255
    t.text     "col2_body"
    t.text     "footnote"
    t.string   "banner_type",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batches", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "uploader_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url",         limit: 255
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size"
    t.string   "data_fingerprint",  limit: 255
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "ckeditor_assets", ["type"], name: "index_ckeditor_assets_on_type", using: :btree

  create_table "collections", force: :cascade do |t|
    t.string   "url",                limit: 255
    t.string   "title",              limit: 255
    t.text     "description"
    t.string   "status",             limit: 255
    t.integer  "author_id"
    t.integer  "maintainer_id"
    t.integer  "type_id"
    t.integer  "organization_id"
    t.integer  "license_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "private"
    t.integer  "view_count"
    t.integer  "activity_id"
    t.boolean  "approved",                       default: false
    t.integer  "counter_cache",                  default: 0
    t.integer  "impressions_count"
    t.integer  "positive"
    t.integer  "negative"
    t.float    "ci_lower_bound"
    t.string   "positive_users",                 default: [],    array: true
    t.string   "negative_users",                 default: [],    array: true
    t.boolean  "newsletter_only",                default: false
  end

  add_index "collections", ["ci_lower_bound"], name: "index_collections_on_ci_lower_bound", using: :btree

  create_table "datasets", force: :cascade do |t|
    t.string   "url",                limit: 255
    t.string   "title",              limit: 255
    t.text     "description"
    t.string   "status",             limit: 255
    t.integer  "author_id"
    t.integer  "maintainer_id"
    t.integer  "type_id"
    t.integer  "organization_id"
    t.integer  "license_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "denial_reasons", force: :cascade do |t|
    t.text     "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "devresults_grades", force: :cascade do |t|
    t.string   "value",      limit: 255
    t.text     "text"
    t.integer  "result_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type", limit: 255
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name",     limit: 255
    t.string   "action_name",         limit: 255
    t.string   "view_name",           limit: 255
    t.string   "request_hash",        limit: 255
    t.string   "ip_address",          limit: 255
    t.string   "session_hash",        limit: 255
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "params"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "licenses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_applications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.boolean  "approved"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
  end

  create_table "organization_types", force: :cascade do |t|
    t.string   "type",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "organization_type", limit: 255
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "url",                  limit: 255
    t.string   "name",                 limit: 255
    t.text     "description"
    t.string   "status",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name",       limit: 255
    t.string   "logo_content_type",    limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.boolean  "approved"
    t.string   "domain",               limit: 255
    t.integer  "organization_type_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string   "url",                     limit: 255
    t.string   "name",                    limit: 255
    t.text     "description"
    t.string   "format",                  limit: 255
    t.integer  "collection_id"
    t.string   "status",                  limit: 255
    t.string   "resource_type",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name",    limit: 255
    t.string   "attachment_content_type", limit: 255
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "author_id"
    t.integer  "organization_id"
    t.integer  "license_id"
    t.boolean  "private",                             default: false
    t.string   "language",                limit: 255
    t.text     "source"
    t.integer  "ipaper_id"
    t.string   "ipaper_access_key",       limit: 255
    t.integer  "view_count"
    t.integer  "batch_id"
    t.text     "corporate_authorship"
    t.integer  "issue_date"
    t.integer  "activity_id"
    t.boolean  "approved",                            default: false
    t.integer  "counter_cache",                       default: 0
    t.integer  "impressions_count"
    t.integer  "positive"
    t.integer  "negative"
    t.float    "ci_lower_bound"
    t.string   "positive_users",                      default: [],    array: true
    t.string   "negative_users",                      default: [],    array: true
    t.boolean  "newsletter_only",                     default: false
  end

  add_index "resources", ["ci_lower_bound"], name: "index_resources_on_ci_lower_bound", using: :btree

  create_table "resourcings", force: :cascade do |t|
    t.integer  "resource_id"
    t.integer  "resourceable_id"
    t.string   "resourceable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id"
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "searches", force: :cascade do |t|
    t.string   "query",            limit: 255
    t.text     "tags"
    t.integer  "organization_id"
    t.integer  "license_id"
    t.string   "resource_type",    limit: 255
    t.string   "language",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "collections_only"
    t.boolean  "resources_only"
  end

  create_table "survey_logs", force: :cascade do |t|
    t.string   "model_type", limit: 255
    t.integer  "model_id"
    t.integer  "user_id"
    t.string   "event",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["context"], name: "index_taggings_on_context", using: :btree
  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
  add_index "taggings", ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
  add_index "taggings", ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
  add_index "taggings", ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
  add_index "taggings", ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "subscribed_to",    limit: 255
    t.integer  "subscribed_to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_types", force: :cascade do |t|
    t.string   "user_type",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: ""
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                   limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "invitation_token",       limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type",        limit: 255
    t.integer  "invitations_count",                  default: 0
    t.text     "about"
    t.string   "title",                  limit: 255
    t.string   "twitter",                limit: 255
    t.string   "facebook",               limit: 255
    t.string   "google",                 limit: 255
    t.string   "linkedin",               limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "password_changed_at"
    t.datetime "expired_at"
    t.datetime "last_activity_at"
    t.integer  "user_type_id"
    t.text     "organization_entered"
    t.boolean  "mail_chimp_user",                    default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["expired_at"], name: "index_users_on_expired_at", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["last_activity_at"], name: "index_users_on_last_activity_at", unique: true, using: :btree
  add_index "users", ["password_changed_at"], name: "index_users_on_password_changed_at", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_organizations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",            limit: 255
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end
