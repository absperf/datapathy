class Client
  include Datapathy::Model
  include Datapathy::Model::MultiFinder

  service_type :kernel
  resource_name :AllClients

  persists :name, :longname, :active

  links_to :parent
  links_to :zendesk_integration
  links_to_collection :hosts

  def self.by_href(href, reload = nil)
    @cache = nil if reload
    @cache ||= all.to_a.map { |a| [a.href, a] }.inject({}){ |ha, (k,v)| ha[k] = v; ha }

    @cache[href]
  end

  def self.const_missing(const)
    if const == :API
      find_by_name("API")
    else
      super
    end
  end

  def and_children
    [
      self,
      Client.find_all_by_parent_href(href).map { |child| child.and_children }
    ].flatten.compact.uniq
  end

  def active?
    attributes[:active]
  end

  def inactive?
    not active?
  end
end
