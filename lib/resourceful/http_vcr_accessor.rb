require 'resourceful'
require 'resourceful/vcr_resource'

module Resourceful
  class HttpVcrAccessor < HttpAccessor
    def resource(uri, opts = {})
      @resources ||= {}
      @resources[uri] ||= VcrResource.new(self, uri, opts)
    end
  end
end
