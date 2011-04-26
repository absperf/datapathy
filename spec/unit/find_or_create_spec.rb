require 'spec_helper'

describe "Model.find_or_create_by_foo" do

  describe "record exists" do
    before do
      @article = Article.create(:title => "FooBar",
                                :text  => "Original text")
    end

    it 'should find it' do
      article = Article.find_or_create_by_title(:title => "FooBar",
                                                :text => "New text")

      article.text.should_not == "New text"
      article.text.should == "Original text"
    end
  end

  describe "record missing" do

    it 'should create it' do
      article = Article.find_or_create_by_title(:title => "FooBar",
                                                :text => "New text")

      article.text.should == "New text"
    end

  end

end

