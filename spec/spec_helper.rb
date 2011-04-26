require 'rubygems'
require 'rspec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'datapathy'

require 'ssbe/models/core'

require 'pp'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Datapathy.adapters[:memory] = Datapathy::Adapters::MemoryAdapter.new

Datapathy.adapters[:ssbe] = Datapathy::Adapters::SsbeAdapter.new(:backend => 'ssbe.localhost',
                                                                 :username => 'dev',
                                                                 :password => 'dev')

Datapathy.adapter = Datapathy.adapters[:ssbe]

RSpec.configure do |config|

  config.include(Matchers)

  config.after do
    Datapathy.adapters[:memory].clear!
  end

end
