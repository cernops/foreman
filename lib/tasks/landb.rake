desc <<-END_DESC
Updates Host owners according to Landb ownership.
END_DESC

namespace :landb do
  @ldap_source = nil
  @ldap_con = nil

  def set_landb_config
    config = begin
               YAML.load(File.open("/etc/puppet/landb_foreman_config.yaml"))
             rescue ArgumentError => e
               puts "Could not parse YAML: #{e.message}"
             end
    LandbClient.set_config(config)
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


  task :refresh_landb_ownership => :environment do
    set_landb_config
    client = LandbClient.instance
    changes = 0

    puts " ================================================================ "
    puts "Import starts: #{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}"

    Host.all.each do |host|
      begin
        landb_owner = client.get_device_info([host.name.split('.')[0]]).device_info.responsible_person
        name = landb_owner.name
        first_name = landb_owner.first_name
        if landb_owner.first_name.downcase == 'e-group'
          landb_owner = Usergroup.find_by_name(landb_owner.name.downcase)
        else
          landb_owner = User.find_by_login(employee_id_to_login(landb_owner.ccid))
        end

        if landb_owner.nil?
          puts "Host - #{host.name} -- current owner: #{host.owner} - landb owner not found in foreman- #{name} - #{first_name}"
          puts '----------------------------------'
        end
        next unless landb_owner.present?
        if landb_owner != host.owner
          changes += 1
          puts "Host - #{host.name} -- current owner: #{host.owner} - landb owner: #{landb_owner}"
          puts (host.update_attribute('owner', landb_owner) || host.errors.messages)
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
