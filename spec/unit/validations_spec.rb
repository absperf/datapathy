require 'spec_helper'

describe "validations" do

  describe "enforced by the model" do
    before do
      @person = Person.new()
    end

    it 'should be invalid' do
      @person.name.should == nil
      @person.valid?.should be_false
      @person.should have_errors_on(:name)
    end
  end

end

