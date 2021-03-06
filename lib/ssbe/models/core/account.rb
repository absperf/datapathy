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

  def self.by_login(login)
    uri = ServiceDescriptor.discover(:kernel, "AllAccounts") + "?login=#{CGI.escape login}"
    response = Datapathy.adapters[:ssbe].http.resource(uri).get(:accept => 'application/vnd.absperf.sskj1+json')
    accounts = JSON.parse(response.body)['items'].map { |account| Account.new(account) }
    accounts.any? ? accounts.first : nil
  end

  def md5_auth_credentials
    @md5_auth_credentials ||=
      Datapathy.adapters[:ssbe].http.
        resource(self[:authentication_credentials_href]).
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
