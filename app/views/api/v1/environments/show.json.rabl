object @environment

attributes :name, :id, :created_at, :updated_at
node(:hosts_count) { |e| e.hosts.count }

