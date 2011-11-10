class Account
  include Datapathy::Model

  service_type :kernel
  resource_name :AllAccounts

  persists :login, :full_name, :time_zone, :password

  links_to_collection :roles_by_client,      :class_name => "Role"
  links_to_collection :clients_by_role,      :class_name => "Client"
  links_to_collection :clients_by_privilege, :class_name => "Client"
  links_to_collection :addresses
  links_to_collection :visible_addresses,    :class_name => "Address"
  links_to_collection :role_assignments
  links_to :preferred_client, :class_name => "Client"
  links_to :initial_client,   :class_name => "Client"
  links_to :initial_role,     :class_name => "Role"

  def self.by_login(login, reload = nil)
    @cache = nil if reload
    @cache ||= all.to_a.map { |a| [a.login, a] }.inject({}){ |ha, (k,v)| ha[k] = v; ha }
    @cache[login]
  end

  def md5_auth_credentials
    @md5_auth_credentials ||=
      Datapathy.default_adapter.http.
        resource(authentication_credentials_href).
        get(:accept => 'application/prs.md5-hexdigest-auth-creds').body
  end

  def has_privilege_at?(privilege, client_or_href)
    if client_or_href.is_a?(Client)
      clients_by_privilege(privilege).include?(client_or_href)
    else
      clients_by_privilege(privilege).map(&:href).include?(client_or_href)
    end
  end

  def has_privilege_at_any_client?(privilege)
    clients_by_privilege(privilege).size > 0
  end

end
