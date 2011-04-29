class AppLink
  include Datapathy::Model
  service_type :kernel
  resource_name :ApplicationLinks

  persists :slug, :title, :target, :order, :pages, :icon_name

  def self.register(attrs = {})
    uri = ServiceDescriptor.discover(:kernel, "RegisterApplicationLink")
    self.create(attrs.merge(:href => uri))
  end
end

