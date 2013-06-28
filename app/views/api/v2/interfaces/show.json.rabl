object @interface => :interface

attributes :id, :ip, :mac, :host_id, :name, :subnet_id, :domain_id

child :attrs do
  attributes :provider, :username, :password
end
