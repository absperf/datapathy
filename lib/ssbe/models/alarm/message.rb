class Message
  include Datapathy::Model

  service_type :escalations

  persists :alert_count, :message, :min_metric_value, :max_metric_value, :first_seen_at, :last_seen_at, :status
  links_to :escalation
  links_to :metric

  def self.make(*args)
    attrs = plan(*args)
    escalation = attrs[:escalation]
    escalation.messages.create(attrs)
  end
end
