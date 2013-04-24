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

ActiveRecord::Schema.define(:version => 20130409081924) do

  create_table "architectures", :force => true do |t|
    t.string   "name",       :limit => 10, :default => "x86_64", :null => false
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "architectures_operatingsystems", :id => false, :force => true do |t|
    t.integer "architecture_id",    :null => false
    t.integer "operatingsystem_id", :null => false
  end

  create_table "audits", :force => true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "username"
    t.string   "action"
    t.text     "audited_changes"
    t.integer  "version",         :default => 0
    t.string   "comment"
    t.integer  "associated_id"
    t.string   "associated_type"
    t.datetime "created_at"
    t.string   "remote_address"
    t.string   "auditable_name"
    t.string   "associated_name"
  end

  add_index "audits", ["associated_id", "associated_type"], :name => "associated_index"
  add_index "audits", ["associated_id", "associated_type"], :name => "auditable_parent_index"
  add_index "audits", ["auditable_id", "auditable_type"], :name => "auditable_index"
  add_index "audits", ["created_at"], :name => "index_audits_on_created_at"
  add_index "audits", ["id"], :name => "index_audits_on_id"
  add_index "audits", ["user_id", "user_type"], :name => "user_index"

  create_table "auth_sources", :force => true do |t|
    t.string   "type",              :limit => 30, :default => "",    :null => false
    t.string   "name",              :limit => 60, :default => "",    :null => false
    t.string   "host",              :limit => 60
    t.integer  "port"
    t.string   "account"
    t.string   "account_password",  :limit => 60
    t.string   "base_dn"
    t.string   "attr_login",        :limit => 30
    t.string   "attr_firstname",    :limit => 30
    t.string   "attr_lastname",     :limit => 30
    t.string   "attr_mail",         :limit => 30
    t.boolean  "onthefly_register",               :default => false, :null => false
    t.boolean  "tls",                             :default => false, :null => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  create_table "bookmarks", :force => true do |t|
    t.string  "name"
    t.text    "query",      :limit => 255
    t.string  "controller"
    t.boolean "public"
    t.integer "owner_id"
    t.string  "owner_type"
  end

  add_index "bookmarks", ["controller"], :name => "index_bookmarks_on_controller"
  add_index "bookmarks", ["name"], :name => "index_bookmarks_on_name"
  add_index "bookmarks", ["owner_id", "owner_type"], :name => "index_bookmarks_on_owner_id_and_owner_type"

  create_table "compute_resources", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "url"
    t.string   "user"
    t.string   "password"
    t.string   "uuid"
    t.string   "type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.text     "attrs"
  end

  create_table "config_templates", :force => true do |t|
    t.string   "name"
    t.text     "template"
    t.boolean  "snippet"
    t.integer  "template_kind_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "config_templates_operatingsystems", :id => false, :force => true do |t|
    t.integer "config_template_id", :null => false
    t.integer "operatingsystem_id", :null => false
  end

  create_table "domains", :force => true do |t|
    t.string   "name",                      :default => "", :null => false
    t.string   "fullname",   :limit => 254
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "dns_id"
  end

  create_table "environment_classes", :force => true do |t|
    t.integer "puppetclass_id", :null => false
    t.integer "environment_id", :null => false
    t.integer "lookup_key_id"
  end

  add_index "environment_classes", ["environment_id"], :name => "index_environments_puppetclasses_on_environment_id"
  add_index "environment_classes", ["puppetclass_id"], :name => "index_environments_puppetclasses_on_puppetclass_id"

  create_table "environments", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fact_names", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "fact_names", ["name"], :name => "index_fact_names_on_name"

  create_table "fact_values", :force => true do |t|
    t.text     "value",        :null => false
    t.integer  "fact_name_id", :null => false
    t.integer  "host_id",      :null => false
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "fact_values", ["fact_name_id"], :name => "index_fact_values_on_fact_name_id"
  add_index "fact_values", ["host_id"], :name => "index_fact_values_on_host_id"

  create_table "features", :force => true do |t|
    t.string   "name",       :limit => 16
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "features_smart_proxies", :id => false, :force => true do |t|
    t.integer "smart_proxy_id"
    t.integer "feature_id"
  end

  create_table "host_classes", :force => true do |t|
    t.integer "puppetclass_id", :null => false
    t.integer "host_id",        :null => false
  end

  create_table "hostgroup_classes", :force => true do |t|
    t.integer "hostgroup_id",   :null => false
    t.integer "puppetclass_id", :null => false
  end

  add_index "hostgroup_classes", ["hostgroup_id"], :name => "index_hostgroups_puppetclasses_on_hostgroup_id"
  add_index "hostgroup_classes", ["puppetclass_id"], :name => "index_hostgroups_puppetclasses_on_puppetclass_id"

  create_table "hostgroups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "environment_id"
    t.integer  "operatingsystem_id"
    t.integer  "architecture_id"
    t.integer  "medium_id"
    t.integer  "ptable_id"
    t.string   "root_pass"
    t.integer  "puppet_ca_proxy_id"
    t.boolean  "use_image"
    t.string   "image_file",         :limit => 128
    t.string   "ancestry"
    t.text     "vm_defaults"
    t.integer  "subnet_id"
    t.integer  "domain_id"
    t.integer  "puppet_proxy_id"
    t.string   "label"
  end

  add_index "hostgroups", ["ancestry"], :name => "index_hostgroups_on_ancestry"

  create_table "hosts", :force => true do |t|
    t.string   "name",                                                  :null => false
    t.string   "ip"
    t.text     "environment"
    t.datetime "last_compile"
    t.datetime "last_freshcheck"
    t.datetime "last_report"
    t.datetime "updated_at"
    t.integer  "source_file_id"
    t.datetime "created_at"
    t.string   "mac",                 :limit => 17,  :default => ""
    t.string   "root_pass",           :limit => 64
    t.string   "serial",              :limit => 12
    t.integer  "puppet_status",                      :default => 0,     :null => false
    t.integer  "domain_id"
    t.integer  "architecture_id"
    t.integer  "operatingsystem_id"
    t.integer  "environment_id"
    t.integer  "subnet_id"
    t.integer  "ptable_id"
    t.integer  "medium_id"
    t.boolean  "build",                              :default => false
    t.text     "comment"
    t.text     "disk"
    t.datetime "installed_at"
    t.integer  "model_id"
    t.integer  "hostgroup_id"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.boolean  "enabled",                            :default => true
    t.integer  "puppet_ca_proxy_id"
    t.boolean  "managed"
    t.boolean  "use_image"
    t.string   "image_file",          :limit => 128
    t.string   "uuid"
    t.integer  "compute_resource_id"
    t.integer  "puppet_proxy_id"
    t.string   "certname"
    t.integer  "image_id"
    t.integer  "organization_id"
    t.integer  "location_id"
    t.string   "type"
  end

  add_index "hosts", ["architecture_id"], :name => "host_arch_id_ix"
  add_index "hosts", ["certname"], :name => "index_hosts_on_certname"
  add_index "hosts", ["domain_id"], :name => "host_domain_id_ix"
  add_index "hosts", ["environment_id"], :name => "host_env_id_ix"
  add_index "hosts", ["hostgroup_id"], :name => "host_group_id_ix"
  add_index "hosts", ["installed_at"], :name => "index_hosts_on_installed_at"
  add_index "hosts", ["last_report"], :name => "index_hosts_on_last_report"
  add_index "hosts", ["medium_id"], :name => "host_medium_id_ix"
  add_index "hosts", ["name"], :name => "index_hosts_on_name"
  add_index "hosts", ["operatingsystem_id"], :name => "host_os_id_ix"
  add_index "hosts", ["puppet_status"], :name => "index_hosts_on_puppet_status"
  add_index "hosts", ["source_file_id"], :name => "index_hosts_on_source_file_id"
  add_index "hosts", ["type"], :name => "index_hosts_on_type"

  create_table "images", :force => true do |t|
    t.integer  "operatingsystem_id"
    t.integer  "compute_resource_id"
    t.integer  "architecture_id"
    t.string   "uuid"
    t.string   "username"
    t.string   "name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "iam_role"
  end

  create_table "inventory_facts", :force => true do |t|
    t.integer  "node_id",    :null => false
    t.string   "name",       :null => false
    t.text     "value",      :null => false
    t.datetime "created_at"
  end

  add_index "inventory_facts", ["node_id", "name"], :name => "index_inventory_facts_on_node_id_and_name", :unique => true

  create_table "inventory_nodes", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "timestamp",  :null => false
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "inventory_nodes", ["name"], :name => "index_inventory_nodes_on_name", :unique => true

  create_table "key_pairs", :force => true do |t|
    t.text     "secret"
    t.integer  "compute_resource_id"
    t.string   "name"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "locations_organizations", :id => false, :force => true do |t|
    t.integer "location_id"
    t.integer "organization_id"
  end

  create_table "logs", :force => true do |t|
    t.integer  "source_id"
    t.integer  "message_id"
    t.integer  "report_id"
    t.integer  "level_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "logs", ["level_id"], :name => "index_logs_on_level_id"
  add_index "logs", ["message_id"], :name => "index_logs_on_message_id"
  add_index "logs", ["report_id"], :name => "index_logs_on_report_id"

  create_table "lookup_keys", :force => true do |t|
    t.string   "key"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.integer  "puppetclass_id"
    t.text     "default_value",       :limit => 255
    t.string   "path"
    t.string   "description"
    t.string   "validator_type"
    t.string   "validator_rule"
    t.boolean  "is_param",                           :default => false
    t.string   "key_type"
    t.boolean  "override",                           :default => false
    t.boolean  "required",                           :default => false
    t.integer  "lookup_values_count",                :default => 0
  end

  add_index "lookup_keys", ["key"], :name => "index_lookup_keys_on_key"
  add_index "lookup_keys", ["path"], :name => "index_lookup_keys_on_path"
  add_index "lookup_keys", ["puppetclass_id"], :name => "index_lookup_keys_on_puppetclass_id"

  create_table "lookup_values", :force => true do |t|
    t.string   "match"
    t.text     "value",         :limit => 255
    t.integer  "lookup_key_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "lookup_values", ["match"], :name => "index_lookup_values_on_match"
  add_index "lookup_values", ["match"], :name => "index_lookup_values_on_priority"

  create_table "media", :force => true do |t|
    t.string   "name",        :limit => 50,  :default => "", :null => false
    t.string   "path",                       :default => "", :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "media_path",  :limit => 128
    t.string   "config_path", :limit => 128
    t.string   "image_path",  :limit => 128
    t.string   "os_family"
  end

  create_table "media_operatingsystems", :id => false, :force => true do |t|
    t.integer "medium_id",          :null => false
    t.integer "operatingsystem_id", :null => false
  end

  create_table "messages", :force => true do |t|
    t.text   "value"
    t.string "digest"
  end

  add_index "messages", ["digest"], :name => "index_messages_on_digest"

  create_table "models", :force => true do |t|
    t.string   "name",           :limit => 64, :null => false
    t.text     "info"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "vendor_class",   :limit => 32
    t.string   "hardware_model", :limit => 16
  end

  create_table "nics", :force => true do |t|
    t.string   "mac"
    t.string   "ip"
    t.string   "type"
    t.string   "name"
    t.integer  "host_id"
    t.integer  "subnet_id"
    t.integer  "domain_id"
    t.text     "attrs"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "nics", ["host_id"], :name => "index_by_host"
  add_index "nics", ["type", "id"], :name => "index_by_type_and_id"
  add_index "nics", ["type"], :name => "index_by_type"

  create_table "notices", :force => true do |t|
    t.string   "content",    :limit => 1024,                   :null => false
    t.boolean  "global",                     :default => true, :null => false
    t.string   "level",                                        :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "operatingsystems", :force => true do |t|
    t.string   "major",         :limit => 5,  :default => "", :null => false
    t.string   "name",          :limit => 64
    t.string   "minor",         :limit => 16, :default => "", :null => false
    t.string   "nameindicator", :limit => 3
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.string   "release_name",  :limit => 64
    t.string   "type",          :limit => 16
  end

  add_index "operatingsystems", ["type"], :name => "index_operatingsystems_on_type"

  create_table "operatingsystems_ptables", :id => false, :force => true do |t|
    t.integer "ptable_id",          :null => false
    t.integer "operatingsystem_id", :null => false
  end

  create_table "operatingsystems_puppetclasses", :id => false, :force => true do |t|
    t.integer "puppetclass_id",     :null => false
    t.integer "operatingsystem_id", :null => false
  end

  create_table "os_default_templates", :force => true do |t|
    t.integer  "config_template_id"
    t.integer  "template_kind_id"
    t.integer  "operatingsystem_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "param_names", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "param_names", ["name"], :name => "index_param_names_on_name"

  create_table "param_values", :force => true do |t|
    t.text     "value",         :null => false
    t.integer  "param_name_id", :null => false
    t.integer  "line"
    t.integer  "resource_id"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "param_values", ["param_name_id"], :name => "index_param_values_on_param_name_id"
  add_index "param_values", ["resource_id"], :name => "index_param_values_on_resource_id"

  create_table "parameters", :force => true do |t|
    t.string   "name"
    t.text     "value",        :limit => 255
    t.integer  "reference_id"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "type"
    t.integer  "priority"
  end

  add_index "parameters", ["reference_id", "type"], :name => "index_parameters_on_host_id_and_type"
  add_index "parameters", ["type"], :name => "index_parameters_on_domain_id_and_type"
  add_index "parameters", ["type"], :name => "index_parameters_on_hostgroup_id_and_type"
  add_index "parameters", ["type"], :name => "index_parameters_on_type"

  create_table "ptables", :force => true do |t|
    t.string   "name",       :limit => 64,   :null => false
    t.string   "layout",     :limit => 4096, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "os_family"
  end

  create_table "puppet_tags", :force => true do |t|
    t.string   "name"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "puppet_tags", ["id"], :name => "index_puppet_tags_on_id"

  create_table "puppetclasses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "puppetclasses", ["name"], :name => "index_puppetclasses_on_name"

  create_table "reports", :force => true do |t|
    t.integer  "host_id",     :null => false
    t.datetime "reported_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "status"
    t.text     "metrics"
  end

  add_index "reports", ["host_id"], :name => "index_reports_on_host_id"
  add_index "reports", ["reported_at", "host_id"], :name => "index_reports_on_reported_at_and_host_id"
  add_index "reports", ["reported_at"], :name => "index_reports_on_reported_at"
  add_index "reports", ["status"], :name => "index_reports_on_status"

  create_table "resource_tags", :force => true do |t|
    t.integer  "resource_id"
    t.integer  "puppet_tag_id"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "resource_tags", ["puppet_tag_id"], :name => "index_resource_tags_on_puppet_tag_id"
  add_index "resource_tags", ["resource_id"], :name => "index_resource_tags_on_resource_id"

  create_table "resources", :force => true do |t|
    t.text     "title",          :null => false
    t.string   "restype",        :null => false
    t.integer  "host_id"
    t.integer  "source_file_id"
    t.boolean  "exported"
    t.integer  "line"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "resources", ["host_id"], :name => "index_resources_on_host_id"
  add_index "resources", ["source_file_id"], :name => "index_resources_on_source_file_id"
  add_index "resources", ["title", "restype"], :name => "index_resources_on_title_and_restype"

  create_table "roles", :force => true do |t|
    t.string  "name",        :limit => 30
    t.integer "builtin"
    t.text    "permissions"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.text     "description"
    t.string   "category"
    t.string   "settings_type"
    t.text     "default",       :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "settings", ["name"], :name => "index_settings_on_name", :unique => true

  create_table "smart_proxies", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "source_files", :force => true do |t|
    t.string   "filename"
    t.string   "path"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  add_index "source_files", ["filename"], :name => "index_source_files_on_filename"

  create_table "sources", :force => true do |t|
    t.text   "value"
    t.string "digest"
  end

  add_index "sources", ["digest"], :name => "index_sources_on_digest"

  create_table "subnet_domains", :force => true do |t|
    t.integer  "domain_id"
    t.integer  "subnet_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "subnets", :force => true do |t|
    t.string   "network",       :limit => 15
    t.string   "mask",          :limit => 15
    t.integer  "priority"
    t.text     "name"
    t.string   "vlanid",        :limit => 10
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.integer  "dhcp_id"
    t.integer  "tftp_id"
    t.string   "gateway"
    t.string   "dns_primary"
    t.string   "dns_secondary"
    t.string   "from"
    t.string   "to"
    t.integer  "dns_id"
  end

  create_table "taxable_taxonomies", :force => true do |t|
    t.integer  "taxonomy_id"
    t.integer  "taxable_id"
    t.string   "taxable_type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "taxable_taxonomies", ["taxable_id", "taxable_type", "taxonomy_id"], :name => "taxable_index"
  add_index "taxable_taxonomies", ["taxable_id", "taxable_type"], :name => "index_taxable_taxonomies_on_taxable_id_and_taxable_type"
  add_index "taxable_taxonomies", ["taxonomy_id"], :name => "index_taxable_taxonomies_on_taxonomy_id"

  create_table "taxonomies", :force => true do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "ignore_types"
  end

  create_table "template_combinations", :force => true do |t|
    t.integer  "config_template_id"
    t.integer  "hostgroup_id"
    t.integer  "environment_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "template_kinds", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tokens", :force => true do |t|
    t.string   "value"
    t.datetime "expires"
    t.integer  "host_id"
  end

  add_index "tokens", ["host_id"], :name => "index_tokens_on_host_id"
  add_index "tokens", ["value"], :name => "index_tokens_on_value"

  create_table "trend_counters", :force => true do |t|
    t.integer  "trend_id"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "trend_counters", ["trend_id"], :name => "index_trend_counters_on_trend_id"

  create_table "trends", :force => true do |t|
    t.string   "trendable_type"
    t.integer  "trendable_id"
    t.string   "name"
    t.string   "type"
    t.string   "fact_value"
    t.string   "fact_name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "trends", ["fact_value"], :name => "index_trends_on_fact_value"
  add_index "trends", ["trendable_type", "trendable_id"], :name => "index_trends_on_trendable_type_and_trendable_id"
  add_index "trends", ["type"], :name => "index_trends_on_type"

  create_table "user_compute_resources", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "compute_resource_id"
  end

  create_table "user_domains", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "domain_id"
  end

  create_table "user_facts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "fact_name_id"
    t.string   "criteria"
    t.string   "operator",     :limit => 3, :default => "="
    t.string   "andor",        :limit => 3, :default => "or"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "user_hostgroups", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "hostgroup_id"
  end

  create_table "user_notices", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "notice_id"
  end

  create_table "user_roles", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.integer "inherited_from"
  end

  create_table "usergroup_members", :force => true do |t|
    t.integer "member_id"
    t.string  "member_type"
    t.integer "usergroup_id"
  end

  create_table "usergroups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "firstname"
    t.string   "lastname"
    t.string   "mail"
    t.boolean  "admin"
    t.datetime "last_login_on"
    t.integer  "auth_source_id"
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
    t.string   "password_hash",           :limit => 128
    t.string   "password_salt",           :limit => 128
    t.integer  "role_id"
    t.string   "domains_andor",           :limit => 3,   :default => "or"
    t.string   "hostgroups_andor",        :limit => 3,   :default => "or"
    t.string   "facts_andor",             :limit => 3,   :default => "or"
    t.boolean  "filter_on_owner"
    t.string   "compute_resources_andor", :limit => 3,   :default => "or"
    t.string   "organizations_andor",     :limit => 3,   :default => "or"
    t.string   "locations_andor",         :limit => 3,   :default => "or"
  end

end
