class Client
  include Datapathy::Model

  service_type :kernel
  resource_name :AllClients

  persists :name, :longname, :active

  links_to :parent
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

end
