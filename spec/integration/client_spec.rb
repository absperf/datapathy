require 'spec_helper'


describe Client do
  each_adapter do

    describe "creating" do

      it 'should work' do
        @client = Client.create(:name => "datapathy-test-#{Time.now.to_i}",
                                :longname => "Datapathy Test #{Time.now.to_i}",
                                :active => true,
                                :parent => Client::API)

        @client.should be_valid
        @client.href.should_not be_nil

      end
    end

  end
end
