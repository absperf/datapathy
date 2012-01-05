require 'resourceful'
require 'resourceful/ssbe_authenticator'
require 'resourceful/http_vcr_accessor'

module Datapathy::Adapters
  class SsbeVcrAdapter < SsbeAdapter
    def initialize(options = {})
      super
      @http = Resourceful::HttpVcrAccessor.new
      @http.logger = @options[:logger] || Datapathy.logger
      @http.cache_manager = Resourceful::InMemoryCacheManager.new unless @options[:disable_cache]
      @http.add_authenticator Resourceful::SsbeAuthenticator.new(@username, @password)
    end
  end
end
