class LastImports

  include Datapathy::Model

  service_type :measurements
  resource_name :AllLastImports

  persists :last_message, :agent_href, :host_href

end
