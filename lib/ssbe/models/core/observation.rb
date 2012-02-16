class Observation
  include Datapathy::Model

  service_type :measurements

  persists :timestamp, :value, :status

  links_to :metric
  links_to :host
  links_to :agent

  def self.in(hrefs, start_time, end_time)
    regex = /\D+(\d+)/
    ids = hrefs.map do |model_href|
      if model_href =~ regex
        regex.match(model_href)[1]
      else
        model_href.split(/\//).last
      end
    end.compact.join(',')

    href = Addressable::URI.parse(ServiceDescriptor.discover(:measurements, "MultipleObservations"))
    href.query_values = {:metric_ids => ids, :start => start_time.iso8601, :end => end_time.iso8601}
    response = Datapathy.adapters[:ssbe].http.resource(href).get(:accept => 'application/vnd.absperf.ssmj1+json')

    JSON.parse(response.body).map { |observation| observation.with_indifferent_access }
  end
end
