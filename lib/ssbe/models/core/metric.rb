
class Metric
  include Datapathy::Model

  service_type :measurements

  persists :path, :status, :metric_type, :active, :value, :historical_observations_href, :active?

  links_to :host
  links_to :status
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
    uri = ServiceDescriptor.discover(:measurements, "DiscoverMetrics") + "?clientname=#{CGI.escape client_name}&hostname=#{CGI.escape host_name}&metric_type=#{CGI.escape metric_name}"
    response = Datapathy.adapters[:ssbe].http.resource(uri).get(:accept => 'application/vnd.absperf.ssmj1+json')

    metrics = JSON.parse(response.body).map { |metric| Metric.new(metric) }

    metrics.any? ? metrics.first : nil
  end

  def visible_to?(account)
    account.has_privilege_at?(self.class.view_privilege, self.host.client.href)
  end

  class << self
    def privilege_name
      @privilege_name ||= self.name.underscore
    end

    %w[view create modify].each do |action|
      class_eval <<-RUBY, __FILE__, __LINE__
        def #{action}_privilege_name
          @#{action}_privilege_name ||= "#{action}_\#{privilege_name}"
        end
        def #{action}_privilege
          @#{action}_privilege ||= Privilege[#{action}_privilege_name]
        end
      RUBY
    end
  end
end
