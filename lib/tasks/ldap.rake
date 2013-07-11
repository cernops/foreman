desc <<-END_DESC
Refreshes LDAP usergroups. It adds to an LDAP usergroup all the foreman users that belong to it, and removes foreman users
in that usergroup that do not belong in LDAP anymore.
END_DESC

namespace :ldap do
  def set_ldap_connection
    @ldap_source ||= AuthSourceLdap.first
    @ldap_con    ||= @ldap_source.send(:initialize_ldap_con, @ldap_source.account, @ldap_source.account_password)
    @treebase = @ldap_source.send(:treebase)
  end


  def employee_login_to_new_user(employee_login)
    set_ldap_connection
    employee_filter = Net::LDAP::Filter.eq("sAMAccountName", employee_login)
    object_filter   = Net::LDAP::Filter.eq("objectClass", 'user')
    primary_filter  = Net::LDAP::Filter.eq("employeeType", 'primary')

    user = @ldap_con.search(:base => @treebase, :filter => employee_filter & object_filter & primary_filter)[0]
    return nil if user.nil?
    User.new( { :login        => employee_login,
             :firstname       => user.givenname.join,
             :lastname        => user.sn.join,
             :mail            => user.mail.join,
             :auth_source     => AuthSourceLdap.find_by_name('CERN'),
             :filter_on_owner => true } )
  end

  def create_users_from_logins(user_logins)
    created_users = []
    user_logins.each do |login|
      new_user = employee_login_to_new_user(login)
      next if user.nil?
      User.as 'admin' do
        if new_user.save
          puts "User '#{new_user.name}' auto-created from #{new_user.auth_source}"
          created_users << User.find_by_login(login)
        else
          "Failed to save User '#{login}' #{new_user.errors.full_messages}"
        end
      end
    end
    created_users
  end

  task :refresh_usergroups => :environment do
    Usergroup.select { |ug| ug.auth_source.is_a?(AuthSourceLdap) }.each(&:refresh_ldap)
  end

  task :create_users_from_egroups => :environment do
    puts " ================================================================ "
    puts "E-groups users sync starts: #{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}"

    Usergroup.all.each do |usergroup|
      new_users     = usergroup.ldap_users - usergroup.users.map(&:login)
      created_users = create_users_from_logins(new_users)
      User.as('admin') { usergroup.users << created_users }
    end

    puts "E-groups users sync ends: #{Time.now.strftime("%Y-%m-%d %H:%M:%S %Z")}"
    puts " ================================================================ "
  end
end
