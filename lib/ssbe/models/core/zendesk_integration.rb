class ZendeskIntegration
  include Datapathy::Model

  persists :active, :password, :subdomain, :username
  links_to :client

end
