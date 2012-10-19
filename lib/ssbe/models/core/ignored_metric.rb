class IgnoredMetric
  include Datapathy::Model

  service_type :measurements

  links_to :metric_filter
  links_to :metric

  persists :metric_uuid
end
