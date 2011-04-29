
Client.blueprint do
  longname    { Faker::Company.name }
  name        { longname.downcase.gsub(/[\s,]/, '') }
  active      { true }
  parent      { Client::API }
end

Client.blueprint(:parent_client) do
  name        { "alarmtest" }
  longname    { "Alarm Test Client" }
  active      { true }
  parent      { Client::API }
end

def parent_client
  @parent_client = Client.find_or_create_by_name Client.plan(:parent_client)
end

Client.blueprint(:child_client) do
  name        { "alarmtestchild" }
  longname    { "Alarm Test Child Client" }
  active      { true }
  parent      { parent_client }
end

def child_client
  @child_client = Client.find_or_create_by_name Client.plan(:child_client)
end

Client.blueprint(:other_client) do
  name        { "alarmtestother" }
  longname    { "Alarm Test Other Client" }
  active      { true }
  parent      { Client::API }
end

def other_client
  @other_client = Client.find_or_create_by_name Client.plan(:other_client)
end

Host.blueprint do
  client      { parent_client }
  name        { Faker::Internet.domain_name }
end

def create_host(*args)
  client = Host.plan(*args)[:client]
  client.hosts.create(Host.plan(*args))
end

MetricType.blueprint do
  path        { Faker::Lorem.words(5).join('|') }
end

Metric.blueprint do
  host         { Host.make }
  path         { Faker::Lorem.words(5).join('|') }
end

MetricFilter.blueprint do
  client      { parent_client }
  purpose     { "AlarmTest" }
  any_or_all  { "all" }
  criteria    { [{:target => "Hostname", :comparison => "is", :pattern => "test"}] }
end

Address.blueprint do
  name        { Faker::Name.first_name }
  delivery_method "email"
  identifier  { Faker::Internet.email(name) }
end
