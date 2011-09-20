def application_name
  Rails.root.basename.to_s
end

Client.blueprint do
  longname    { Faker::Company.name }
  name        { longname.downcase.gsub(/[\s,]/, '') }
  active      { true }
  parent      { Client::API }
end

Client.blueprint(:parent_client) do
  name        { "#{application_name}test" }
  longname    { "#{application_name.titleize} Test Client" }
  active      { true }
  parent      { Client::API }
end

def parent_client
  @parent_client = Client.find_or_create_by_name Client.plan(:parent_client)
end

Client.blueprint(:child_client) do
  name        { "#{application_name}testchild" }
  longname    { "#{application_name.titleize} Test Child Client" }
  active      { true }
  parent      { parent_client }
end

def child_client
  @child_client = Client.find_or_create_by_name Client.plan(:child_client)
end

Client.blueprint(:other_client) do
  name        { "#{application_name}testother" }
  longname    { "#{application_name.titleize} Test Other Client" }
  active      { true }
  parent      { Client::API }
end

def other_client
  @other_client = Client.find_or_create_by_name Client.plan(:other_client)
end

Host.blueprint do
  client      { parent_client }
  name        { "example-#{Time.now.to_f}.com" }
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
  purpose     { "#{application_name.titleize}Test" }
  any_or_all  { "all" }
  criteria    { [{:target => "Hostname", :comparison => "is", :pattern => "test"}] }
end

Address.blueprint do
  name        { Faker::Name.first_name }
  delivery_method "email"
  identifier  { Faker::Internet.email(name) }
end

EscalationDefinition.blueprint do
  filter { MetricFilter.make }
  client        { parent_client }
  active        true
end

Escalation.blueprint do
  escalation_definition    { EscalationDefinition.make }
  current_escalation_state { :new }
  current_status           { Escalation::Crit }
  current_step             { 1 }
end

Message.blueprint do
  escalation       { Escalation.make }
  metric           { Metric.make }
  alert_count      { rand(10).to_i }
  message          { Faker::Lorem.sentence }
  status           { Escalation::Crit }
  min_metric_value { rand.to_f }
  max_metric_value { rand(100).to_f }
  first_seen_at    { Time.now }
  last_seen_at     { Time.now }
end

Agent.blueprint do
  host { Host.make }
  client { parent_client }
end
