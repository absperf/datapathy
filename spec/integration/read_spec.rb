require 'spec_helper'

describe "reading records", :type => :integration do
  each_adapter do


    it 'should work' do
      clients = Client.all
    end

  end

end
