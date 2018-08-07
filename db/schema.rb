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

ActiveRecord::Schema.define(version: 20180731023729) do

  create_table "objetivos", force: :cascade do |t|
    t.decimal  "proyeccion_mensual",              precision: 10, scale: 2
    t.decimal  "porcentaje_proyectado",           precision: 10, scale: 2
    t.decimal  "valor",                           precision: 10, scale: 2
    t.integer  "variable_id",           limit: 4
    t.integer  "user_id",               limit: 4
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.integer  "mes",                   limit: 4
    t.integer  "anio",                  limit: 4
  end

  add_index "objetivos", ["user_id", "variable_id", "mes", "anio"], name: "index_objetivos_on_user_id_and_variable_id_and_mes_and_anio", unique: true, using: :btree
  add_index "objetivos", ["user_id"], name: "index_objetivos_on_user_id", using: :btree
  add_index "objetivos", ["variable_id"], name: "index_objetivos_on_variable_id", using: :btree

  create_table "registros", force: :cascade do |t|
    t.date     "fecha"
    t.integer  "codigo_sucursal", limit: 4
    t.integer  "variable_id",     limit: 4
    t.decimal  "value",                     precision: 10, scale: 2
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  add_index "registros", ["codigo_sucursal"], name: "index_registros_on_codigo_sucursal", using: :btree
  add_index "registros", ["fecha"], name: "fecha", using: :btree
  add_index "registros", ["fecha"], name: "index_registros_on_fecha", using: :btree
  add_index "registros", ["variable_id"], name: "index_registros_on_variable_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", limit: 4
    t.integer "user_id", limit: 4
  end

  add_index "roles_users", ["role_id"], name: "index_roles_users_on_role_id", using: :btree
  add_index "roles_users", ["user_id"], name: "index_roles_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "nombre",                 limit: 255
    t.string   "apellido",               limit: 255
    t.string   "password_digest",        limit: 255
    t.string   "codigo_sucursal",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
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
    t.integer  "year_points",            limit: 4,   default: 0
    t.integer  "current_month_points",   limit: 4,   default: 0
  end

  add_index "users", ["codigo_sucursal"], name: "index_users_on_codigo_sucursal", using: :btree
  add_index "users", ["current_month_points"], name: "index_users_on_current_month_points", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["year_points"], name: "index_users_on_year_points", using: :btree

  create_table "variables", force: :cascade do |t|
    t.string   "nombre",          limit: 255
    t.string   "tipo",            limit: 255
    t.integer  "puntaje",         limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "codigo_variable", limit: 4
    t.boolean  "inverse"
    t.boolean  "is_admin"
  end

  add_index "variables", ["codigo_variable"], name: "index_variables_on_codigo_variable", using: :btree

  add_foreign_key "objetivos", "users"
  add_foreign_key "objetivos", "variables"
  add_foreign_key "registros", "variables"
end
