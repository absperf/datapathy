require 'spec_helper'

describe "reading records", :type => :integration do

  it 'should work' do
    clients = Client.all
    p clients.to_a
  end

end
