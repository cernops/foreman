class Usergroup < ActiveRecord::Base
  include Authorization

  has_many :usergroup_members, :dependent => :destroy
  has_many :users,      :through => :usergroup_members, :source => :member, :source_type => 'User'
  has_many :usergroups, :through => :usergroup_members, :source => :member, :source_type => 'Usergroup'

  has_many :hosts, :as => :owner

  belongs_to :auth_source

  validate :in_auth_source?, :if => lambda { |ug| ug.auth_source.present? && auth_source.type == "AuthSourceLdap" }
  validates_uniqueness_of :name
  before_destroy EnsureNotUsedBy.new(:hosts, :usergroups)

  # The text item to see in a select dropdown menu
  alias_attribute :select_title, :to_s
  default_scope :order => 'LOWER(usergroups.name)'
  scoped_search :on => :name, :complete_value => :true
  validate :ensure_uniq_name

  # This methods retrieves all user addresses in a usergroup
  # Returns: Array of strings representing the user's email addresses
  def recipients
    all_users.map(&:mail).flatten.sort.uniq
  end

  # This methods retrieves all users in a usergroup
  # Returns: Array of users
  def all_users(group_list=[self], user_list=[])
    retrieve_users_and_groups group_list, user_list
    user_list.sort.uniq
  end

  # This methods retrieves all usergroups in a usergroup
  # Returns: Array of unique usergroups
  def all_usergroups(group_list=[self], user_list=[])
    retrieve_users_and_groups group_list, user_list
    group_list.sort.uniq
  end

  def as_json(options={})
    super({:only => [:name, :id]})
  end

  def refresh_ldap
    ldap_userlist = ldap_users
    current_users = users.map(&:login)

    old_ldap_users = current_users - ldap_userlist
    new_ldap_users = ldap_userlist - current_users 

    remove_users(old_ldap_users) 
    add_users(new_ldap_users)
  end

  def ldap_users
    auth_source.is_a?(AuthSourceLdap) ? auth_source.userlist(name) : []
  end

  protected
  # Recurses down the tree of usergroups and finds the users
  # [+group_list+]: Array of Usergroups that have already been processed
  # [+users+]     : Array of users accumulated at this point
  # Returns       : Array of non unique users
  def retrieve_users_and_groups(group_list, user_list)
    for group in usergroups
      next if group_list.include? group
      group_list << group

      group.retrieve_users_and_groups(group_list, user_list)
    end
    user_list.concat users
  end

  def ensure_uniq_name
    errors.add :name, "is already used by a user account" if User.where(:login => name).first
  end


  def in_auth_source?(source = auth_source)
    errors.add :auth_source_id, "is not an LDAP user group" unless source.includes_cn?(name)
  end

  def add_users(userlist)
    users << User.where( { :login => userlist } )
  end

  def remove_users(userlist)
    old_users = User.select { |user| userlist.include?(user.login) } 
    self.users = self.users - old_users 
  end

end
