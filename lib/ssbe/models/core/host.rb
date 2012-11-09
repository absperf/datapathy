
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

  def all_metrics
    coll = Datapathy::Collection.new(Metric)
    coll.href = attributes[:metrics_href]+'?show=all'
    coll.select({})
  end

  def active_metrics
    coll = Datapathy::Collection.new(Metric)
    coll.href = attributes[:metrics_href]+'?show=current'
    coll.select({})
  end

  def active?
    attributes[:active?] == 1
  end

  def inactive?
    !active?
  end
end
