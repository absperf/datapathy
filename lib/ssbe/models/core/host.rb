
class Host
  include Datapathy::Model
  include Datapathy::Model::MultiFinder

  service_type :measurements
  resource_name :AllHosts

  persists :name, :active, :tags

  links_to :client
  links_to_collection :metrics

  def self.make(*args)
    attrs = plan(*args)
    client = attrs[:client]
    client.hosts.create(attrs)
  end
end
