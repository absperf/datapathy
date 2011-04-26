require 'spec_helper'

describe 'deleteing models' do

  before do
    @record_a = @record = Article.create(:title => "Datapathy is amazing!", :text => "It really is!")
    @record_b =           Article.create(:title => "Datapathy is awesome!", :text => "Try it today!")
    @record_c =           Article.create(:title => "Datapathy is awesome!", :text => "Title is same, but text is different")

    @records = [@record_a, @record_b, @record_c]
  end

  describe 'one at a time' do
    before do
      Article[@record[:href]].delete
    end

    it 'should remove the record' do
      lambda {
        Article[@record[:href]]
      }.should raise_error(Datapathy::RecordNotFound)
    end

    it 'should not delete other records' do
      Article[@record_b[:href]].should_not be_nil
    end
  end

end
