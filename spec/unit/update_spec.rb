require 'spec_helper'

describe 'updating models' do

  before do
    @record = Article.create :title => "Datapathy is amazing!", :text => "It really is!"
  end

  before do
    @article = Article[@record[:href]]
    @article.title = "Datapathy is /still/ amazing!"
    @article.save
  end

  it 'should update the attributes' do
    @article.title.should == "Datapathy is /still/ amazing!"
  end

  it 'should not update other attributes' do
    expect {
      @article = Article[@record[:href]]
      @article.title = "Datapathy is /still/ amazing!"
      @article.save
    }.to_not change {

      @article.href

    }
  end

end


