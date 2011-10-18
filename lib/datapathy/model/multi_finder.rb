# This module is not included in Datapathy models by default. In order to use
# this module the index action of the controller associated with the resource
# must be modified to handle an ids parameter that will receive the
# comma-separated list of ids to return.
module Datapathy::Model
  module MultiFinder
    extend ActiveSupport::Concern

    module ClassMethods
      def in(model_hrefs, options = {})
        collection = Datapathy::Collection.new(self)
        href = options[:href] || collection.href
        regex = /^#{href}\//

        ids = model_hrefs.map do |model_href|
          if model_href =~ regex
            model_href.gsub(regex, '') if model_href =~ regex
          else
            model_href.split(/\//).last
          end
        end.compact.join(',')

        collection.href = Addressable::URI.parse(href)
        collection.href.query_values = {:ids => ids}
        collection
      end
    end
  end
end
