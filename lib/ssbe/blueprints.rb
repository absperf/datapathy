
p Client.class.ancestors
Client.blueprint do
  longname    { Faker::Company.name }
  name        { longname.downcase.gsub(' ', '') }
  active      { true }
  parent_href { Client::API.href }
end

Client.blueprint(:parent_client) do
  name        { "alarmtest" }
  longname    { "Alarm Test Client" }
  active      { true }
  parent_href { Client::API.href }
end

Client.blueprint(:child_client) do
  name        { "alarmtestchild" }
  longname    { "Alarm Test Child Client" }
  active      { true }
  parent_href { parent_client.href }
end

Client.blueprint(:other_client) do
  name        { "alarmtestother" }
  longname    { "Alarm Test Other Client" }
  active      { true }
  parent_href { Client::API.href }
end

Host.blueprint do
  client_href { parent_client.href }
  name        { Faker::Internet.domain_name }
end

MetricType.blueprint do
  path        { Faker::Lorem.words(5).join('|') }
end

Metric.blueprint do
  subject_href { Host.make.href }
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
