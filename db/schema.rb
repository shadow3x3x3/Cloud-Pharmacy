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

ActiveRecord::Schema.define(version: 20150707102612) do

  create_table "af_nurse_handling", primary_key: "nurseHandlingID", force: :cascade do |t|
    t.string "mode",           limit: 17,  null: false
    t.string "doctorDo",       limit: 8
    t.string "doctorReson",    limit: 255
    t.string "otherHanding",   limit: 255
    t.string "residentFollow", limit: 255, null: false
    t.date   "followingDate",              null: false
  end

  create_table "af_pharmacist_assess", primary_key: "pharmacistAssessID", force: :cascade do |t|
    t.string "assessmentResult", limit: 0,   null: false
    t.string "suggestion",       limit: 255, null: false
    t.string "referenceData",    limit: 6,   null: false
    t.string "referenceBooks",   limit: 10,  null: false
    t.date   "assessmentDate",               null: false
  end

  create_table "af_prescription_content", primary_key: "prescriptionContentID", force: :cascade do |t|
    t.string  "hospitalName1", limit: 64
    t.string  "division1",     limit: 64
    t.date    "doctorDate1"
    t.integer "days1",         limit: 4
    t.string  "remark1",       limit: 255
    t.string  "hospitalName2", limit: 64
    t.string  "division2",     limit: 64
    t.date    "doctorDate2"
    t.integer "days2",         limit: 4
    t.string  "remark2",       limit: 255
    t.string  "hospitalName3", limit: 64
    t.string  "division3",     limit: 64
    t.date    "doctorDate3"
    t.integer "days3",         limit: 4
    t.string  "remark3",       limit: 255
  end

  create_table "agency", primary_key: "agencyID", force: :cascade do |t|
    t.string  "name",            limit: 64,  null: false
    t.string  "abbreviation",    limit: 64,  null: false
    t.integer "phone",           limit: 4,   null: false
    t.integer "fax",             limit: 4,   null: false
    t.integer "pharmacistID",    limit: 4,   null: false
    t.string  "address",         limit: 255, null: false
    t.string  "color",           limit: 64
    t.date    "lastDeliveryDay"
  end

  add_index "agency", ["pharmacistID"], name: "agency_pharmacist_id", using: :btree

  create_table "assessment_form", id: false, force: :cascade do |t|
    t.integer  "afID",                  limit: 4,   null: false
    t.integer  "residentID",            limit: 4,   null: false
    t.date     "fillOutDate",                       null: false
    t.string   "afDruguse",             limit: 7,   null: false
    t.string   "afLiverFunction",       limit: 2,   null: false
    t.string   "afKidneyFunction",      limit: 2,   null: false
    t.string   "allergyDrug",           limit: 255
    t.string   "allergyFood",           limit: 255
    t.string   "referenceAccessories",  limit: 7,   null: false
    t.integer  "prescriptionContentID", limit: 4,   null: false
    t.integer  "pharmacistAssessID",    limit: 4,   null: false
    t.integer  "nurseHandlingID",       limit: 4,   null: false
    t.datetime "timestamp",                         null: false
  end

  add_index "assessment_form", ["nurseHandlingID"], name: "af_nurse_handing_id", using: :btree
  add_index "assessment_form", ["pharmacistAssessID"], name: "af_pharmacist_assess_id", using: :btree
  add_index "assessment_form", ["prescriptionContentID"], name: "af_prescription_content_1", using: :btree

  create_table "delivery", primary_key: "deliveryID", force: :cascade do |t|
    t.string  "address",        limit: 255, null: false
    t.integer "quantity",       limit: 4,   null: false
    t.date    "date",                       null: false
    t.string  "session",        limit: 16,  null: false
    t.integer "pharmacistID",   limit: 4,   null: false
    t.integer "prescriptionID", limit: 4,   null: false
  end

  add_index "delivery", ["pharmacistID"], name: "delivery_pharmacist_id", using: :btree
  add_index "delivery", ["prescriptionID"], name: "delivery_prescription_id", using: :btree

  create_table "drug", primary_key: "drugID", force: :cascade do |t|
    t.string  "oriName",   limit: 255, null: false
    t.string  "chiName",   limit: 255, null: false
    t.integer "stock",     limit: 4,   null: false
    t.integer "price",     limit: 4,   null: false
    t.string  "picture",   limit: 255
    t.boolean "isChronic", limit: 1,   null: false
  end

  create_table "fit", primary_key: "fitID", force: :cascade do |t|
    t.string  "fitIdNumber",    limit: 16,  null: false
    t.string  "name",           limit: 64,  null: false
    t.string  "phoneOffice",    limit: 16
    t.string  "phoneHome",      limit: 16,  null: false
    t.string  "cellphone",      limit: 16,  null: false
    t.string  "address",        limit: 255, null: false
    t.date    "birthday",                   null: false
    t.integer "prescriptionId", limit: 4
    t.integer "deliveryID",     limit: 4
  end

  create_table "fit_of_member", primary_key: "fitID", force: :cascade do |t|
    t.integer "memberID", limit: 4, null: false
  end

  add_index "fit_of_member", ["memberID"], name: "member_id_number", using: :btree

  create_table "hospital", primary_key: "hospitalID", force: :cascade do |t|
    t.string  "name",     limit: 64,  null: false
    t.string  "address",  limit: 255, null: false
    t.boolean "isDrugID", limit: 1,   null: false
  end

  create_table "member", primary_key: "memberID", force: :cascade do |t|
    t.string "memberIdNumber",  limit: 16,  null: false
    t.string "email",           limit: 64,  null: false
    t.string "name",            limit: 64,  null: false
    t.string "phone",           limit: 16,  null: false
    t.string "password",        limit: 16,  null: false
    t.string "password_digest", limit: 255
  end

  create_table "pharmacist", primary_key: "pharmacistID", force: :cascade do |t|
    t.string  "name",          limit: 64,                null: false
    t.integer "salary",        limit: 4,                 null: false
    t.integer "deliveryTimes", limit: 4,     default: 0, null: false
    t.text    "remark",        limit: 65535
  end

  create_table "prescription", primary_key: "prescriptionID", force: :cascade do |t|
    t.boolean "phoneStatus",      limit: 1,  null: false
    t.integer "days",             limit: 4,  null: false
    t.integer "deliveryTimes",    limit: 4,  null: false
    t.date    "doctorDate",                  null: false
    t.boolean "obtainStatus",     limit: 1,  null: false
    t.integer "compoundingTimes", limit: 4,  null: false
    t.date    "firstDate"
    t.date    "secondDate"
    t.string  "personAdded",      limit: 16
    t.string  "lastModifier",     limit: 16
    t.integer "hospitalID",       limit: 4,  null: false
    t.string  "uploadMode",       limit: 6,  null: false
  end

  add_index "prescription", ["hospitalID"], name: "prescription_hospital_id", using: :btree

  create_table "prescription_drug_id", id: false, force: :cascade do |t|
    t.integer  "prescriptionID", limit: 4, null: false
    t.datetime "timestamp",                null: false
    t.integer  "drugID",         limit: 4, null: false
  end

  add_index "prescription_drug_id", ["drugID"], name: "drug_id", using: :btree

  create_table "prescription_file", id: false, force: :cascade do |t|
    t.integer  "prescriptionID", limit: 4,   null: false
    t.datetime "timestamp",                  null: false
    t.string   "file",           limit: 255
  end

  create_table "prescription_of_all", primary_key: "prescriptionID", force: :cascade do |t|
    t.integer  "userID",        limit: 4, null: false
    t.string   "identityCheck", limit: 8, null: false
    t.datetime "timestamp",               null: false
  end

  create_table "resident", primary_key: "residentID", force: :cascade do |t|
    t.string  "residentIdNumber", limit: 16, null: false
    t.string  "name",             limit: 64, null: false
    t.date    "birthday",                    null: false
    t.integer "bedNumber",        limit: 4,  null: false
    t.integer "liveFloor",        limit: 4,  null: false
    t.integer "agencyID",         limit: 4,  null: false
  end

  add_index "resident", ["agencyID"], name: "resident_agency_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "agency", "pharmacist", column: "pharmacistID", primary_key: "pharmacistID", name: "agency_ibfk_1"
  add_foreign_key "assessment_form", "af_nurse_handling", column: "nurseHandlingID", primary_key: "nurseHandlingID", name: "assessment_form_ibfk_8"
  add_foreign_key "assessment_form", "af_pharmacist_assess", column: "pharmacistAssessID", primary_key: "pharmacistAssessID", name: "assessment_form_ibfk_1"
  add_foreign_key "assessment_form", "af_prescription_content", column: "prescriptionContentID", primary_key: "prescriptionContentID", name: "assessment_form_ibfk_7"
  add_foreign_key "assessment_form", "resident", column: "residentID", primary_key: "residentID", name: "assessment_form_ibfk_6"
  add_foreign_key "delivery", "pharmacist", column: "pharmacistID", primary_key: "pharmacistID", name: "delivery_ibfk_1"
  add_foreign_key "delivery", "prescription", column: "prescriptionID", primary_key: "prescriptionID", name: "delivery_ibfk_2"
  add_foreign_key "fit", "fit_of_member", column: "fitID", primary_key: "fitID", name: "fit_ibfk_1"
  add_foreign_key "fit_of_member", "member", column: "memberID", primary_key: "memberID", name: "fit_of_member_ibfk_1"
  add_foreign_key "prescription", "hospital", column: "hospitalID", primary_key: "hospitalID", name: "prescription_ibfk_1"
  add_foreign_key "prescription", "prescription_of_all", column: "prescriptionID", primary_key: "prescriptionID", name: "prescription_ibfk_2"
  add_foreign_key "prescription_drug_id", "drug", column: "drugID", primary_key: "drugID", name: "prescription_drug_id_ibfk_2"
  add_foreign_key "prescription_drug_id", "prescription", column: "prescriptionID", primary_key: "prescriptionID", name: "prescription_drug_id_ibfk_1"
  add_foreign_key "prescription_file", "prescription", column: "prescriptionID", primary_key: "prescriptionID", name: "prescription_file_ibfk_1"
  add_foreign_key "resident", "agency", column: "agencyID", primary_key: "agencyID", name: "resident_ibfk_1"
end
