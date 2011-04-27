class AppLink
  include Datapathy::Model
  service_type :kernel
  resource_name :ApplicationLinks

  persists :slug, :title, :target, :order, :pages, :icon_name

  def self.register(attrs = {})
    resource = ServiceDescriptor[service_type].resource_for("RegisterApplicationLink")
    self.create(attrs.merge(:href => resource.href))
  end
end

