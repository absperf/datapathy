
class Host
  include Datapathy::Model

  service_type :measurements

  persists :name, :active, :tags

  links_to :client
  links_to_collection :metrics

  def self.make(*args)
    attrs = plan(*args)
    client = attrs[:client]
    client.hosts.create(attrs)
  end
end
