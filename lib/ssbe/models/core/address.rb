class Address
  include Datapathy::Model
  service_type :kernel
  resource_name :AllAddresses

  persists :name, :identifier, :delivery_method

  EMAIL_REGEXP = /[A-Z0-9._%+-]+@[A-Z0-9.-]+/i

  links_to :account

  def self.by_href(href, reload = nil)
    @cache = nil if reload
    @cache ||= all.to_a.map { |a| [a.href, a] }.inject({}){ |ha, (k,v)| ha[k] = v; ha }

    @cache[href]
  end

  def to_s
    "#{name} <#{identifier}>"
  end

end
