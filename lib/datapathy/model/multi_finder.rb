# This module is not included in Datapathy models by default. In order to use
# this module the index action of the controller associated with the resource
# must be modified to handle an ids parameter that will receive the
# comma-separated list of ids to return.
module Datapathy::Model
  module MultiFinder
    extend ActiveSupport::Concern

    module ClassMethods
      # Fetches all models in an array of hrefs. The hrefs can be specified as
      # either a collection of hrefs or as a collection of objects and a method
      # to map the objects to.
      #
      # Examples:
      #
      # You can pass an array of hrefs:
      #   Model.in(['http://example.com/test/1', 'http://example.com/test/2'])
      #
      # Or you can just pass a series of hrefs:
      #   Model.in('http://example.com/test/1', 'http://example.com/test/2')
      #
      # Or a collection of parent objects and the method to map them to to get
      # the collection of hrefs:
      #   Model.in(parent_models, :children_hrefs)
      #
      # This is equivalent to calling
      #   Model.in(parent_models.map(&:children_hrefs).flatten)
      #
      # A hash is returned where the key is the href and the value is the model.
      #
      def in(*args)
        case args.length
        when 1
          model_hrefs = [args.first].flatten
        when 2
          if args.first.kind_of? String
            model_hrefs = args
          else
            model_hrefs = args.first.map { |model| model.send(args.second) }
          end
        else
          model_hrefs = args
        end

        collection = Datapathy::Collection.new(self)
        href = collection.href
        regex = /^#{href}\//

        ids = model_hrefs.flatten.uniq.map do |model_href|
          if model_href =~ regex
            model_href.gsub(regex, '')
          else
            model_href.split(/\//).last
          end
        end.compact.join(',')

        collection.href = Addressable::URI.parse(href)
        collection.href.query_values = {:ids => ids}
        collection.inject({}) { |hash, model| hash.merge(model.href => model) }
      end
    end
  end
end
