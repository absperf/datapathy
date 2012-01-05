require 'resourceful'
require 'digest/md5'
require 'vcr'

module Resourceful
  class VcrResource < Resource
    def request_with_vcr(method, data, header)
      header = default_header.merge(header)
      ensure_content_type(data, header) if data

      cassette_name = Digest::MD5.hexdigest([method.to_s, uri.to_s, data.to_s, header.to_hash.to_s].join('_'))

      VCR.use_cassette(cassette_name) do
        request_without_vcr(method, data, header)
      end
    end

    alias_method_chain :request, :vcr
  end
end
