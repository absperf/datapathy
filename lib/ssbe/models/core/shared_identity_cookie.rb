class SharedIdentityCookie
  def self.public_key
    @public_key ||= begin
                      uri = ServiceDescriptor.discover(:kernel, "SharedIdentityCookieRsaPublicKey")
                      response = Datapathy.adapters[:ssbe].http.resource(uri).get(:accept => 'application/x-pem-file')
                      response.body
                    end
  end
end
