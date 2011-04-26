
class Host
  include Datapathy::Model

  service_type :measurements

  persists :name, :active, :tags

  links_to :client
  links_to_collection :hosts

  def create
    client.hosts.create(self)
  end

end
