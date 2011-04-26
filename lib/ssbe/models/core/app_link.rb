class AppLink
  include Datapathy::Model
  service_type :kernel
  resource_name :ApplicationLinks

  persists :slug, :title, :target, :order, :pages, :icon_name

  def self.register(*args)
    resource = ServiceDescriptor[service_type].resource_for("RegisterApplicationLink")
    self.from(resource.href).create(*args)
  end
end

