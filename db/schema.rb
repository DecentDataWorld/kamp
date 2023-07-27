# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_27_151348) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "url", limit: 255
    t.text "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "announcements", force: :cascade do |t|
    t.string "name", null: false
    t.string "short_description"
    t.text "long_description"
    t.datetime "expiration_date"
    t.boolean "is_private", default: false, null: false
    t.boolean "is_featured", default: false, null: false
    t.bigint "user_id", null: false
    t.bigint "cop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cop_id"], name: "index_announcements_on_cop_id"
    t.index ["user_id"], name: "index_announcements_on_user_id"
  end

  create_table "banners", id: :serial, force: :cascade do |t|
    t.boolean "visible"
    t.string "heading", limit: 255
    t.text "intro_text"
    t.string "col1_heading", limit: 255
    t.text "col1_body"
    t.string "col2_heading", limit: 255
    t.text "col2_body"
    t.text "footnote"
    t.string "banner_type", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "batches", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "uploader_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "url", limit: 255
  end

  create_table "ckeditor_assets", id: :serial, force: :cascade do |t|
    t.string "data_file_name", limit: 255, null: false
    t.string "data_content_type", limit: 255
    t.integer "data_file_size"
    t.string "data_fingerprint", limit: 255
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "collections", id: :serial, force: :cascade do |t|
    t.string "url", limit: 255
    t.string "title", limit: 255
    t.text "description"
    t.string "status", limit: 255
    t.integer "author_id"
    t.integer "maintainer_id"
    t.integer "type_id"
    t.integer "organization_id"
    t.integer "license_id"
    t.text "notes"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "image_file_name", limit: 255
    t.string "image_content_type", limit: 255
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
    t.boolean "private"
    t.integer "view_count"
    t.integer "activity_id"
    t.boolean "approved", default: false
    t.integer "counter_cache", default: 0
    t.integer "impressions_count"
    t.integer "positive"
    t.integer "negative"
    t.float "ci_lower_bound"
    t.string "positive_users", limit: 255, default: [], array: true
    t.string "negative_users", limit: 255, default: [], array: true
    t.boolean "newsletter_only", default: false
    t.index "to_tsvector('english'::regconfig, (((title)::text || ' '::text) || description))", name: "idx_fts_collections_concat", using: :gin
    t.index "to_tsvector('english'::regconfig, (title)::text)", name: "idx_fts_collections_name", using: :gin
    t.index "to_tsvector('english'::regconfig, description)", name: "idx_fts_collections_description", using: :gin
    t.index ["ci_lower_bound"], name: "index_collections_on_ci_lower_bound"
    t.index ["organization_id"], name: "index_collections_on_organization_id"
  end

  create_table "cops", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "admin_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_cops_on_admin_id"
  end

  create_table "cops_resources", id: false, force: :cascade do |t|
    t.bigint "cop_id", null: false
    t.bigint "resource_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cop_id", "resource_id"], name: "index_cops_resources_on_cop_id_and_resource_id"
    t.index ["resource_id", "cop_id"], name: "index_cops_resources_on_resource_id_and_cop_id"
  end

  create_table "cops_users", id: false, force: :cascade do |t|
    t.bigint "cop_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cop_id", "user_id"], name: "index_cops_users_on_cop_id_and_user_id"
    t.index ["user_id", "cop_id"], name: "index_cops_users_on_user_id_and_cop_id"
  end

  create_table "datasets", id: :serial, force: :cascade do |t|
    t.string "url", limit: 255
    t.string "title", limit: 255
    t.text "description"
    t.string "status", limit: 255
    t.integer "author_id"
    t.integer "maintainer_id"
    t.integer "type_id"
    t.integer "organization_id"
    t.integer "license_id"
    t.text "notes"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "image_file_name", limit: 255
    t.string "image_content_type", limit: 255
    t.integer "image_file_size"
    t.datetime "image_updated_at", precision: nil
  end

  create_table "denial_reasons", id: :serial, force: :cascade do |t|
    t.text "reason"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "devresults_grades", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255
    t.text "text"
    t.integer "result_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.string "short_description"
    t.text "long_description"
    t.datetime "date"
    t.string "location"
    t.boolean "is_virtual"
    t.string "url"
    t.string "is_private"
    t.boolean "is_featured"
    t.bigint "user_id"
    t.bigint "cop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cop_id"], name: "index_events_on_cop_id"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "featured_searches", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon_identifier"
    t.bigint "cop_id"
    t.index ["cop_id"], name: "index_featured_searches_on_cop_id"
  end

  create_table "impressions", id: :serial, force: :cascade do |t|
    t.string "impressionable_type", limit: 255
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name", limit: 255
    t.string "action_name", limit: 255
    t.string "view_name", limit: 255
    t.string "request_hash", limit: 255
    t.string "ip_address", limit: 255
    t.string "session_hash", limit: 255
    t.text "message"
    t.text "referrer"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "params"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index"
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "licenses", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "organization_applications", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "organization_id"
    t.boolean "approved"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "comment"
  end

  create_table "organization_types", id: :serial, force: :cascade do |t|
    t.string "type", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "organization_type", limit: 255
  end

  create_table "organizations", id: :serial, force: :cascade do |t|
    t.string "url", limit: 255
    t.string "name", limit: 255
    t.text "description"
    t.string "status", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "logo_file_name", limit: 255
    t.string "logo_content_type", limit: 255
    t.integer "logo_file_size"
    t.datetime "logo_updated_at", precision: nil
    t.boolean "approved"
    t.string "domain", limit: 255
    t.integer "organization_type_id"
  end

  create_table "resources", id: :serial, force: :cascade do |t|
    t.string "url", limit: 255
    t.string "name", limit: 255
    t.text "description"
    t.string "format", limit: 255
    t.integer "collection_id"
    t.string "status", limit: 255
    t.string "resource_type", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "attachment_file_name", limit: 255
    t.string "attachment_content_type", limit: 255
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at", precision: nil
    t.integer "author_id"
    t.integer "organization_id"
    t.integer "license_id"
    t.boolean "private", default: false
    t.string "language", limit: 255
    t.text "source"
    t.integer "ipaper_id"
    t.string "ipaper_access_key", limit: 255
    t.integer "view_count"
    t.integer "batch_id"
    t.text "corporate_authorship"
    t.integer "issue_date"
    t.integer "activity_id"
    t.boolean "approved", default: false
    t.integer "counter_cache", default: 0
    t.integer "impressions_count"
    t.integer "positive"
    t.integer "negative"
    t.float "ci_lower_bound"
    t.string "positive_users", limit: 255, default: [], array: true
    t.string "negative_users", limit: 255, default: [], array: true
    t.boolean "newsletter_only", default: false
    t.bigint "cop_id"
    t.boolean "cop_private", default: false, null: false
    t.index "to_tsvector('english'::regconfig, (((name)::text || ' '::text) || description))", name: "idx_fts_resources_concat", using: :gin
    t.index "to_tsvector('english'::regconfig, (name)::text)", name: "idx_fts_resources_name", using: :gin
    t.index "to_tsvector('english'::regconfig, description)", name: "idx_fts_resources_description", using: :gin
    t.index ["ci_lower_bound"], name: "index_resources_on_ci_lower_bound"
    t.index ["cop_id"], name: "index_resources_on_cop_id"
    t.index ["organization_id"], name: "index_resources_on_organization_id"
  end

  create_table "resourcings", id: :serial, force: :cascade do |t|
    t.integer "resource_id"
    t.integer "resourceable_id"
    t.string "resourceable_type", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "resource_id"
    t.string "resource_type", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "searches", id: :serial, force: :cascade do |t|
    t.string "query", limit: 255
    t.text "tags"
    t.integer "organization_id"
    t.integer "license_id"
    t.string "resource_type", limit: 255
    t.string "language", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "collections_only"
    t.boolean "resources_only"
    t.integer "days_back"
  end

  create_table "survey_logs", id: :serial, force: :cascade do |t|
    t.string "model_type", limit: 255
    t.integer "model_id"
    t.integer "user_id"
    t.string "event", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "tag_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type", limit: 255
    t.integer "tagger_id"
    t.string "tagger_type", limit: 255
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tag_id"], name: "taggable_resources_index"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "taggings_count", default: 0
    t.bigint "tag_type_id"
    t.index ["name"], name: "index_tags_on_name", unique: true
    t.index ["tag_type_id"], name: "index_tags_on_tag_type_id"
  end

  create_table "types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "user_subscriptions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "subscribed_to", limit: 255
    t.integer "subscribed_to_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "user_types", id: :serial, force: :cascade do |t|
    t.string "user_type", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: ""
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name", limit: 255
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email", limit: 255
    t.string "invitation_token", limit: 255
    t.datetime "invitation_created_at", precision: nil
    t.datetime "invitation_sent_at", precision: nil
    t.datetime "invitation_accepted_at", precision: nil
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type", limit: 255
    t.integer "invitations_count", default: 0
    t.text "about"
    t.string "title", limit: 255
    t.string "twitter", limit: 255
    t.string "facebook", limit: 255
    t.string "google", limit: 255
    t.string "linkedin", limit: 255
    t.string "avatar_file_name", limit: 255
    t.string "avatar_content_type", limit: 255
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at", precision: nil
    t.datetime "password_changed_at", precision: nil
    t.datetime "expired_at", precision: nil
    t.datetime "last_activity_at", precision: nil
    t.integer "user_type_id"
    t.text "organization_entered"
    t.boolean "mail_chimp_user", default: false
    t.datetime "deactivated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["expired_at"], name: "index_users_on_expired_at", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["last_activity_at"], name: "index_users_on_last_activity_at", unique: true
    t.index ["password_changed_at"], name: "index_users_on_password_changed_at", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_organizations", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "organization_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "role", limit: 255
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  add_foreign_key "announcements", "cops"
  add_foreign_key "announcements", "users"
  add_foreign_key "cops", "users", column: "admin_id"
  add_foreign_key "events", "cops"
  add_foreign_key "events", "users"
  add_foreign_key "featured_searches", "cops"
  add_foreign_key "resources", "cops"
  add_foreign_key "tags", "tag_types"
end
