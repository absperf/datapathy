require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/array/wrap'

module Datapathy::Adapters

  class MemoryAdapter < AbstractAdapter

    def initialize(options = {})
      super
    end

    def post(uri, data)
      href = [uri, id].join('/')
      resource = {:href => href}.merge(data)
      records_for(uri)[href] = {:href => href}.merge(data)
      resource
    end

    def get(uri)
      if uri.split('/').last =~ /^\d+$/
        records_for(uri)[uri]
      else
        records = records_for(uri)
        {
          :href => uri,
          :item_count => records.size,
          :items => records.values
        }
      end
    end

    def put(uri, data)
      records_for(uri)[uri] = data
      data
    end

    def delete(uri)
      records_for(uri).delete(uri)
    end

    def records_for(uri)
      resource = resource_from_uri(uri)
      datastore[resource]
    end

    def datastore
      @datastore ||= Hash.new { |h,k| h[k] = {} }
    end

    def clear!
      @datastore = nil
    end

    protected

    def resource_from_uri(uri)
      parts = uri.split('/')
      if parts.last =~ /^\d+$/
        parts[-2]                 # /hosts/123         #=> hosts
      else
        parts.last                # /clients/x/hosts   #=> hosts
      end
    end

    def id
      (Time.now.to_f * 1_000_000).to_i
    end

  end

end

