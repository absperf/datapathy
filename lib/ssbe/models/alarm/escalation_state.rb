class EscalationState
  include Datapathy::Model

  service_type :escalations

  persists :slug, :name, :position

  def [](slug)
    find_by_slug(slug)
  end
end
