# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_29_074358) do

  create_table "addcashes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "begintime"
    t.datetime "endtime"
    t.integer "status"
    t.text "summary"
    t.integer "limittype"
    t.integer "priority"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "addcashgis", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "addcash_id"
    t.bigint "product_id"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addcash_id"], name: "index_addcashgis_on_addcash_id"
    t.index ["product_id"], name: "index_addcashgis_on_product_id"
  end

  create_table "addcashgives", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "addcash_id"
    t.bigint "product_id"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addcash_id"], name: "index_addcashgives_on_addcash_id"
    t.index ["product_id"], name: "index_addcashgives_on_product_id"
  end

  create_table "addcashlocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "addcashproduct_id"
    t.float "number"
    t.string "ordernumber"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addcashproduct_id"], name: "index_addcashlocks_on_addcashproduct_id"
  end

  create_table "addcashproducts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "addcash_id"
    t.bigint "product_id"
    t.float "innumber"
    t.float "outnumber"
    t.float "limitnumber"
    t.float "buynumber"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addcash_id"], name: "index_addcashproducts_on_addcash_id"
    t.index ["product_id"], name: "index_addcashproducts_on_product_id"
  end

  create_table "addcashusers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "addcash_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["addcash_id"], name: "index_addcashusers_on_addcash_id"
    t.index ["user_id"], name: "index_addcashusers_on_user_id"
  end

  create_table "addrs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.string "contact"
    t.string "phone"
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "address"
    t.string "adcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_addrs_on_user_id"
  end

  create_table "admingroupauths", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "admingroup_id"
    t.bigint "auth_id"
    t.integer "level"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admingroup_id"], name: "index_admingroupauths_on_admingroup_id"
    t.index ["auth_id"], name: "index_admingroupauths_on_auth_id"
  end

  create_table "admingroups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admingroups_admins", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.bigint "admingroup_id", null: false
  end

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "login"
    t.string "password_digest"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "agentprices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "agent_id"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agent_id"], name: "index_agentprices_on_agent_id"
    t.index ["product_id"], name: "index_agentprices_on_product_id"
  end

  create_table "agents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.float "deposit"
    t.float "task"
    t.bigint "corder"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "onfront"
  end

  create_table "areas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "adcode"
    t.decimal "lng", precision: 15, scale: 12
    t.decimal "lat", precision: 15, scale: 12
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "auths", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "auth"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "buycarconditions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "buycar_id"
    t.bigint "buyparam_id"
    t.string "buyparam"
    t.bigint "buyoption_id"
    t.string "buyoption"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buycar_id"], name: "index_buycarconditions_on_buycar_id"
  end

  create_table "buycars", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.float "number"
    t.float "amount"
    t.integer "producttype"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id"
    t.index ["user_id"], name: "index_buycars_on_user_id"
  end

  create_table "buyfullgiveproducts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "buyfull_id"
    t.bigint "product_id"
    t.float "givenumber"
    t.float "innumber"
    t.float "outnumber"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyfull_id", "product_id"], name: "index_buyfullgiveproducts_on_buyfull_id_and_product_id"
  end

  create_table "buyfulllocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "buyfullgiveproduct_id"
    t.float "number"
    t.string "ordernumber"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyfullgiveproduct_id"], name: "index_buyfulllocks_on_buyfullgiveproduct_id"
  end

  create_table "buyfullproducts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "buyfull_id"
    t.bigint "product_id"
    t.float "buynumber"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyfull_id", "product_id"], name: "index_buyfullproducts_on_buyfull_id_and_product_id"
  end

  create_table "buyfulls", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "begintime"
    t.datetime "endtime"
    t.integer "status"
    t.text "summary"
    t.integer "priority"
    t.integer "limittype"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "buyfullusers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "buyfull_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyfull_id"], name: "index_buyfullusers_on_buyfull_id"
  end

  create_table "buyparamoptions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "buyparam_id"
    t.string "name"
    t.float "weighting"
    t.float "weight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "buyparamoptionimg"
    t.index ["buyparam_id"], name: "index_buyparamoptions_on_buyparam_id"
  end

  create_table "buyparams", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_buyparams_on_product_id"
  end

  create_table "charges", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.float "charge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ordernumber"
    t.string "summary"
    t.index ["user_id"], name: "index_charges_on_user_id"
  end

  create_table "delivereletemplates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "temid"
    t.integer "isdefault"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "delivermodes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.float "weighting"
    t.integer "isdefault"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "keyword"
  end

  create_table "delivermodes_products", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "delivermode_id", null: false
    t.bigint "product_id", null: false
    t.index ["delivermode_id", "product_id"], name: "index_delivermodes_products_on_delivermode_id_and_product_id"
    t.index ["product_id", "delivermode_id"], name: "index_delivermodes_products_on_product_id_and_delivermode_id"
  end

  create_table "delivermodes_sellers", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "delivermode_id", null: false
    t.bigint "seller_id", null: false
    t.index ["delivermode_id", "seller_id"], name: "index_delivermodes_sellers_on_delivermode_id_and_seller_id"
    t.index ["seller_id", "delivermode_id"], name: "index_delivermodes_sellers_on_seller_id_and_delivermode_id"
  end

  create_table "depots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "buyparamoption_id"
    t.float "number"
    t.float "cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "total"
    t.float "warn"
    t.index ["buyparamoption_id"], name: "index_depots_on_buyparamoption_id"
    t.index ["product_id"], name: "index_depots_on_product_id"
  end

  create_table "elesheets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "partnerid"
    t.string "partnerkey"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "evaluateimgs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "evaluate_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "evaluateimg"
    t.index ["evaluate_id"], name: "index_evaluateimgs_on_evaluate_id"
  end

  create_table "evaluates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "product_id"
    t.float "postal"
    t.float "describe"
    t.float "service"
    t.text "summary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "niming"
    t.index ["order_id"], name: "index_evaluates_on_order_id"
    t.index ["product_id"], name: "index_evaluates_on_product_id"
  end

  create_table "examines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "begintime"
    t.datetime "endtime"
    t.integer "examinestatus"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exchangerates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.float "rate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "expresscodes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "company"
    t.string "comcode"
    t.string "summary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "freights", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id"
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_freights_on_order_id"
  end

  create_table "indepotdetails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "indepot_id"
    t.bigint "product_id"
    t.bigint "buyparamoption_id"
    t.float "number"
    t.float "cost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyparamoption_id"], name: "index_indepotdetails_on_buyparamoption_id"
    t.index ["indepot_id"], name: "index_indepotdetails_on_indepot_id"
    t.index ["product_id"], name: "index_indepotdetails_on_product_id"
  end

  create_table "indepots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "ordernumber"
    t.integer "status"
    t.string "handle"
    t.string "reviewer"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "cost"
  end

  create_table "inventordetails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "inventor_id"
    t.float "currentnumber"
    t.float "realnumber"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["inventor_id"], name: "index_inventordetails_on_inventor_id"
  end

  create_table "inventors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "ordernumber"
    t.string "handle"
    t.string "reviewer"
    t.text "summary"
    t.integer "status"
    t.float "currentcost"
    t.float "realcost"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "limitdiscountlocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "limitdiscountproduct_id"
    t.float "number"
    t.string "ordernumber"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["limitdiscountproduct_id"], name: "index_limitdiscountlocks_on_limitdiscountproduct_id"
  end

  create_table "limitdiscountproducts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "limitdiscount_id"
    t.bigint "product_id"
    t.float "rate"
    t.float "innumber"
    t.float "outnumber"
    t.float "limitnumber"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "basenumber"
    t.index ["limitdiscount_id"], name: "index_limitdiscountproducts_on_limitdiscount_id"
    t.index ["product_id"], name: "index_limitdiscountproducts_on_product_id"
  end

  create_table "limitdiscounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "begintime"
    t.datetime "endtime"
    t.integer "status"
    t.text "summary"
    t.integer "limittype"
    t.integer "priority"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.float "basenumber"
  end

  create_table "limitdiscountusers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "limitdiscount_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["limitdiscount_id"], name: "index_limitdiscountusers_on_limitdiscount_id"
  end

  create_table "orderdelivers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id"
    t.integer "state"
    t.integer "ischeck"
    t.string "com"
    t.string "nu"
    t.text "cdata"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "company"
    t.string "eleimg_file_name"
    t.string "eleimg_content_type"
    t.bigint "eleimg_file_size"
    t.datetime "eleimg_updated_at"
    t.index ["order_id"], name: "index_orderdelivers_on_order_id"
  end

  create_table "orderdetailconditions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "orderdetail_id"
    t.bigint "buyparam_id"
    t.string "buyparam"
    t.bigint "buyoption_id"
    t.string "buyoption"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["orderdetail_id"], name: "index_orderdetailconditions_on_orderdetail_id"
  end

  create_table "orderdetails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "order_id"
    t.float "number"
    t.float "price"
    t.integer "producttype"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "outdepotstatus"
    t.index ["order_id"], name: "index_orderdetails_on_order_id"
    t.index ["product_id"], name: "index_orderdetails_on_product_id"
  end

  create_table "orderprintdetails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "orderprint_id"
    t.bigint "orderproduct_id"
    t.float "number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["orderprint_id"], name: "index_orderprintdetails_on_orderprint_id"
    t.index ["orderproduct_id"], name: "index_orderprintdetails_on_orderproduct_id"
  end

  create_table "orderprints", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "username"
    t.string "userphone"
    t.string "ordernumber"
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "address"
    t.string "adcode"
    t.string "sendaddress"
    t.string "senduser"
    t.string "sendphone"
    t.string "receiveuser"
    t.string "receivephone"
    t.text "summary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orderproducts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "selfnumber"
    t.string "name"
    t.string "spec"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "paytype_id"
    t.string "ordernumber"
    t.integer "paystatus"
    t.datetime "paytime"
    t.integer "deliverstatus"
    t.datetime "delivertime"
    t.integer "receivestatus"
    t.datetime "receivetime"
    t.integer "evaluatestatus"
    t.datetime "evaluatetime"
    t.integer "status"
    t.text "summary"
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.integer "producttype"
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "address"
    t.string "contact"
    t.string "phone"
    t.string "adcode"
    t.string "sendcontact"
    t.string "sendphone"
  end

  create_table "outdepotdetails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "outdepot_id"
    t.bigint "product_id"
    t.bigint "buyparamoption_id"
    t.float "number"
    t.float "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyparamoption_id"], name: "index_outdepotdetails_on_buyparamoption_id"
    t.index ["outdepot_id"], name: "index_outdepotdetails_on_outdepot_id"
    t.index ["product_id"], name: "index_outdepotdetails_on_product_id"
  end

  create_table "outdepots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "ordernumber"
    t.string "relordernumber"
    t.string "handle"
    t.string "reviewer"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "paytypes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "paytype"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "postalpolicareas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "postalpolic_id"
    t.string "name"
    t.string "adcode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["postalpolic_id"], name: "index_postalpolicareas_on_postalpolic_id"
  end

  create_table "postalpolics", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.float "weight"
    t.float "outweight"
    t.float "weightprice"
    t.float "freeweight"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "productbanners", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "corder"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "productbanner"
    t.index ["product_id"], name: "index_productbanners_on_product_id"
  end

  create_table "productclas", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "keyword"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "onhome"
  end

  create_table "productclas_products", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "productcla_id", null: false
  end

  create_table "productpvs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.integer "pv"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_productpvs_on_product_id"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "subname"
    t.string "barcode"
    t.float "number"
    t.float "weight"
    t.text "content"
    t.integer "onsale"
    t.integer "presale"
    t.float "price"
    t.string "unit"
    t.string "pinyin"
    t.string "fullpinyin"
    t.integer "trial"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "cover"
    t.integer "pv"
    t.bigint "seller_id"
    t.index ["seller_id"], name: "index_products_on_seller_id"
  end

  create_table "products_statements", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "statement_id", null: false
  end

  create_table "products_todaydeals", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "todaydeal_id", null: false
  end

  create_table "productshares", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.string "productshare"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_productshares_on_product_id"
  end

  create_table "profits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id"
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_profits_on_order_id"
  end

  create_table "quarters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "begintime"
    t.datetime "endtime"
    t.string "yearname"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "realnames", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.string "realname"
    t.string "phone"
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "address"
    t.string "adcode"
    t.integer "status"
    t.string "modifymsg"
    t.string "vcode"
    t.datetime "vcodetime"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_realnames_on_user_id"
  end

  create_table "receiveadds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.string "contact"
    t.string "phone"
    t.string "province"
    t.string "city"
    t.string "district"
    t.string "address"
    t.string "adcode"
    t.integer "isdefault"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "lng", precision: 15, scale: 12
    t.decimal "lat", precision: 15, scale: 12
    t.index ["user_id"], name: "index_receiveadds_on_user_id"
  end

  create_table "reportlostdetails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "reportlost_id"
    t.bigint "product_id"
    t.bigint "buyparamoption_id"
    t.float "number"
    t.text "summary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyparamoption_id"], name: "index_reportlostdetails_on_buyparamoption_id"
    t.index ["product_id"], name: "index_reportlostdetails_on_product_id"
    t.index ["reportlost_id"], name: "index_reportlostdetails_on_reportlost_id"
  end

  create_table "reportlosts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "ordernumber"
    t.string "handle"
    t.string "reviewer"
    t.text "summary"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reportoverflowdetails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "reportoverflow_id"
    t.bigint "product_id"
    t.bigint "buyparamoption_id"
    t.float "number"
    t.text "summary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["buyparamoption_id"], name: "index_reportoverflowdetails_on_buyparamoption_id"
    t.index ["product_id"], name: "index_reportoverflowdetails_on_product_id"
    t.index ["reportoverflow_id"], name: "index_reportoverflowdetails_on_reportoverflow_id"
  end

  create_table "reportoverflows", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "ordernumber"
    t.text "summary"
    t.string "handle"
    t.string "reviewer"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "resources", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "resource_file_name"
    t.string "resource_content_type"
    t.bigint "resource_file_size"
    t.datetime "resource_updated_at"
  end

  create_table "sellers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.decimal "lng", precision: 15, scale: 12
    t.decimal "lat", precision: 15, scale: 12
    t.integer "status"
    t.string "cover"
    t.text "summary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "login"
    t.string "password_digest"
    t.string "contact"
    t.string "contactphone"
  end

  create_table "settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "wxappid"
    t.string "wxappsecret"
    t.integer "autooutdepot"
    t.integer "receivetime"
    t.integer "evaluatetime"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "amapkey"
    t.string "qrcode"
    t.string "partnerid"
    t.string "sendmanname"
    t.string "sendmanmobile"
    t.string "sendmanprintaddr"
    t.string "kuaidikey"
    t.string "kuaidicustomer"
    t.string "kuaidisecret"
  end

  create_table "shophours", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "seller_id"
    t.time "begintime"
    t.time "endtime"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["seller_id"], name: "index_shophours_on_seller_id"
  end

  create_table "showparams", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id"
    t.string "name"
    t.string "param"
    t.bigint "corder"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_showparams_on_product_id"
  end

  create_table "statements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "statement"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "todaydeals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.datetime "begintime"
    t.datetime "endtime"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "useragents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "agent_id"
    t.bigint "user_id"
    t.string "name"
    t.integer "examine"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "quarter_id"
    t.index ["agent_id"], name: "index_useragents_on_agent_id"
    t.index ["quarter_id"], name: "index_useragents_on_quarter_id"
    t.index ["user_id"], name: "index_useragents_on_user_id"
  end

  create_table "useralia", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "aliauser_id"
    t.string "aliasname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["aliauser_id"], name: "index_useralia_on_aliauser_id"
    t.index ["user_id"], name: "index_useralia_on_user_id"
  end

  create_table "userincomes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "user_id"
    t.float "amount"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "summary"
    t.index ["order_id"], name: "index_userincomes_on_order_id"
    t.index ["user_id"], name: "index_userincomes_on_user_id"
  end

  create_table "userpastrecords", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "examine_id"
    t.bigint "last_id"
    t.bigint "current_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["examine_id"], name: "index_userpastrecords_on_examine_id"
    t.index ["user_id"], name: "index_userpastrecords_on_user_id"
  end

  create_table "userrealsales", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "user_id"
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_userrealsales_on_order_id"
    t.index ["user_id"], name: "index_userrealsales_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "openid"
    t.string "unionid"
    t.string "token"
    t.string "nickname"
    t.string "name"
    t.string "aliasname"
    t.string "headurl"
    t.integer "realnamestatus"
    t.integer "isagent"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "up_id"
    t.float "balance"
    t.float "income"
    t.float "deposit"
    t.decimal "lng", precision: 15, scale: 12
    t.decimal "lat", precision: 15, scale: 12
    t.string "city"
    t.index ["up_id", "token"], name: "index_users_on_up_id_and_token"
  end

  create_table "usersales", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "user_id"
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_usersales_on_order_id"
    t.index ["user_id"], name: "index_usersales_on_user_id"
  end

  create_table "usertasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "order_id"
    t.bigint "agent_id"
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agent_id"], name: "index_usertasks_on_agent_id"
    t.index ["order_id"], name: "index_usertasks_on_order_id"
    t.index ["user_id"], name: "index_usertasks_on_user_id"
  end

  create_table "withdrawals", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.float "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_withdrawals_on_user_id"
  end

end
