module Resourceful
  class SsbeAuthenticator
    require 'httpauth'
    require 'addressable/uri'

    attr_reader :username, :password, :realm, :domain, :challenge

    def initialize(username, password)
      @username, @password = username, password
      @realm = 'SystemShepherd'
      @domain = nil
    end

    def update_credentials(challenge_response)
      @domain = Addressable::URI.parse(challenge_response.uri).host
      @challenge = get_challenge_from_header(challenge_response.header['WWW-Authenticate'])
    end

    def get_challenge_from_header(header)
      header = header.join(', ')
      challenge = HTTPAuth::Digest::Challenge.from_header(get_digest_auth_challenge_header(header))
    rescue HTTPAuth::UnwellformedHeader
      false
    end

    def valid_for?(challenge_response)
      return false unless challenge_header = challenge_response.header['WWW-Authenticate']
      !!get_challenge_from_header(challenge_header)
    end

    def can_handle?(request)
      @challenge && Addressable::URI.parse(request.uri).host == @domain
    end

    def add_credentials_to(request)
      request.header['Authorization'] = credentials_for(request)
    end

    def credentials_for(request)
      HTTPAuth::Digest::Credentials.from_challenge(@challenge,
                                                   :username => @username,
                                                   :password => @password,
                                                   :method   => request.method.to_s.upcase,
                                                   :uri      => Addressable::URI.parse(request.uri).path).to_header
    end

    def get_digest_auth_challenge_header(header)
      header.split(',').map(&:strip).reject { |part| part =~ /^Basic/ }.join(', ')
    end
  end
end
