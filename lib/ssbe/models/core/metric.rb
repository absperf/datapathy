
class Metric
  include Datapathy::Model

  service_type :measurements

  persists :path, :metric_type, :active, :status, :value, :historical_observations_href, :active?

  links_to :host
  #links_to :metric_type  # NOTE: collides with {metric_type} hash embedded in metric document
  links_to_collection :observations
  links_to_collection :matching_filters, :class_name => "MetricFilter"

  def self.make(*args)
    attrs = plan(*args)
    host = attrs[:host]
    host.metrics.create(attrs)
  end

  def self.discover(client_name, host_name, metric_name)
    http =
    uri = ServiceDescriptor.discover(:measurements, "DiscoverMetrics") + "?clientname=#{client_name}&hostname=#{host_name}&metric_type=#{metric_name}"
    response = Datapathy.adapters[:ssbe].http.resource(uri).get(:accept => 'application/vnd.absperf.ssmj1+json')

    metrics = JSON.parse(response.body).map { |metric| Metric.new(metric) }

    metrics.any? ? metrics.first : nil
  end
end
