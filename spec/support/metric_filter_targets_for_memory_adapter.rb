module RSpec::MetricFilterTargetHelpers

  def make_metric_filter_targets
    [
      {
        "name"              => "Metric Type (Path)",
        "target"            => "MetricType",
        "valid_comparisons" => [ "is", "is_not", "matches", "does_not_match", "begins_with", "ends_with", "contains", "does_not_contain" ]
      },
      {
        "name"              => "Hostname",
        "target"            => "Hostname",
        "valid_comparisons" => [ "is", "is_not", "matches", "does_not_match" ]
      },
      {
        "name"              => "Client Name",
        "target"            => "Clientname",
        "valid_comparisons" => [ "is", "is_not", "matches", "does_not_match" ]
      },
      {
        "name"              => "Host Tags",
        "target"            => "HostTag",
        "valid_comparisons" => [ "include" ]
      }
    ].each do |target|
      MetricFilterTarget.create(target)
    end

  end

  RSpec.configure { |c| c.include self }
end

