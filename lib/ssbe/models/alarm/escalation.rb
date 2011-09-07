class Escalation
  include Datapathy::Model

  service_type :escalations
  resource_name :AllEscalations

  persists :current_status, :current_step, :current_escalation_state
  links_to :escalation_definition
  links_to_collection :messages

  Ok   = 0
  Warn = 1
  Crit = 2

  def self.make(*args)
    attrs = plan(*args)
    create(attrs)
  end
end
