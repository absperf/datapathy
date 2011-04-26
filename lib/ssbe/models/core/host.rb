
class Host < SsbeModel

  service_type :measurements

  persists :name, :active, :tags, :client_href, :metrics_href

  def client
    Client.at(client_href)
  end

  def metrics
    Metric.from(metrics_href)
  end

  def create
    client.hosts.create(self)
  end

end
