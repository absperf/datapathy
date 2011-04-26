require 'rubygems'
require 'rspec'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'datapathy'

require 'faker'
require 'machinist/datapathy'
require 'ssbe/models/core'
require 'ssbe/blueprints'

require 'pp'
require 'ap'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Datapathy.adapters[:memory] = Datapathy::Adapters::MemoryAdapter.new

Datapathy.adapters[:ssbe] = Datapathy::Adapters::SsbeAdapter.new(:backend => 'ssbe.localhost',
                                                                 :username => 'dev',
                                                                 :password => 'dev')

RSpec.configure do |config|

  config.before :each do
    if example.metadata[:adapter] == :memory
      Datapathy.adapter = Datapathy.adapters[:memory]
      api = Client.create(:name => "API", :longname => "Absolute Performance", :active => true)
    end
  end

  config.after :each do
    Datapathy.adapters[:memory].clear!
    Datapathy.adapters[:default].clear!
  end

end

