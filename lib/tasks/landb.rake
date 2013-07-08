desc <<-END_DESC
Updates Host owners according to Landb ownership.
END_DESC

namespace :landb do
  @ldap_source = nil
  @ldap_con = nil


  def get_landb_config
    config = begin
               YAML.load(File.open("/etc/puppet/landb_foreman_config.yaml"))
             rescue ArgumentError => e
               puts "Could not parse YAML: #{e.message}"
             end
  end

  def set_landb_config
    LandbClient.set_config(get_landb_config)
  end

  def employee_id_to_login(employee_id)
    @ldap_source ||= AuthSourceLdap.first
    @ldap_con    ||= @ldap_source.send(:initialize_ldap_con, @ldap_source.account, @ldap_source.account_password)
    treebase = @ldap_source.send(:treebase)
    employee_filter = Net::LDAP::Filter.eq("employeeID", employee_id)
    object_filter   = Net::LDAP::Filter.eq("objectClass", 'user')
    primary_filter  = Net::LDAP::Filter.eq("employeeType", 'primary')

    @ldap_con.search(:base => treebase, :filter => employee_filter & object_filter & primary_filter)[0].cn[0]
  end

  def create_owner(landb_owner)
    # If the owner was found in landb, this means it's also in LDAP
    new_owner = (landb_owner.first_name.downcase == 'e-group') ? create_new_usergroup(landb_owner) :
      create_new_user(landb_owner)
    User.as 'admin' do
      if new_owner.save
        puts "User '#{new_owner.name}' auto-created from #{new_owner.auth_source}"
      else
        "Failed to save User '#{landb_owner.name.downcase}' #{new_owner.errors.full_messages}"
      end
    end

    new_owner
  end

  def create_usergroup_from_landb(landb_owner)
    Usergroup.new( { :name           => landb_owner.name.downcase,
                     :auth_source_id => AuthSourceLdpa.find_by_name('CERN').id } )
  end

  def create_user_from_landb(landb_owner)
    User.new( { :login        => employee_id_to_login(landb_owner.ccid),
             :firstname       => landb_owner.first_name,
             :lastname        => landb_owner.name,
             :mail            => landb_owner.email,
             :auth_source     => AuthSourceLdap.find_by_name('CERN'),
             :filter_on_owner => true } )
  end


  task :refresh_landb_ownership => :environment do
    set_landb_config
    client = LandbClient.instance
    changes = 0

    puts " ================================================================ "
    puts "Import starts: #{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}"

    Host.all.each do |host|
      begin
        landb_owner = client.get_device_info([host.name.split('.')[0]]).device_info.responsible_person
        if landb_owner.first_name.downcase == 'e-group'
          host_owner_login = Usergroup.find_by_name(landb_owner.name.downcase)
        else
          host_owner_login = User.find_by_login(employee_id_to_login(landb_owner.ccid))
        end

        if host_owner_login.nil?
          puts "Host - #{host.name} -- current owner: #{host.owner} - landb owner not found in foreman - #{landb_owner.name} - #{landb_owner.first_name}"
          host_owner_login = create_owner(landb_owner)
          puts '----------------------------------'
        end
        next unless host_owner_login.present?
        if host_owner_login != host.owner
          changes += 1
          puts "Host - #{host.name} -- current owner: #{host.owner} - landb owner: #{host_owner_login}"
          puts (host.update_attribute('owner', host_owner_login) || host.errors.messages)
          puts '----------------------------------'
        end
      rescue
        next
      end
    end

    puts "Changes ---------  #{changes}"
    puts "Import ends: #{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}"
    puts " ================================================================ "
  end
end

