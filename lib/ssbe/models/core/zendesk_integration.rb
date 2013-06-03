class ZendeskIntegration
  include Datapathy::Model
  persists :active, :token, :subdomain, :username
  links_to :client
end

ZendeskIntegration::Worker = ZendeskWorker
