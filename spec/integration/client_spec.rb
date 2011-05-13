require 'spec_helper'


describe Client do
  each_adapter do

    describe "creating" do
      before do
        @client = Client.make
      end

      subject { @client }

      it { should_not be_new_record }
      it { should_not have_errors }
      it { should have_attribute(:href) }
      it { should have_attribute(:created_at) }

    end

  end
end
