class MetricRanking
  include Datapathy::Model

  service_type :analytics
  resource_name :CorrelatedMetrics

  def self.correlated_metrics(metric_href, escalation_href)
    uri = "#{ServiceDescriptor.discover(:analytics, "CorrelatedMetrics")}?metric_href=#{URI.escape metric_href}&escalation_href=#{URI.escape escalation_href}"
    response = Datapathy.adapters[:ssbe].http.resource(uri).get(:accept => 'application/vnd.absperf.ssmj1+json')

    correlated_metrics = JSON.parse(response.body)
  end
end
