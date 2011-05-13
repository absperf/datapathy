require 'spec_helper'

describe Datapathy::Model do

  class Post
    include Datapathy::Model
    persists :title, :text
  end

  class Comment
    include Datapathy::Model
    persists :text
  end

  it 'should allow persistable attributes to be defined' do
    Post.attributes.should include(:title)
    Post.attributes.should include(:text)
  end

  it 'should allow additional persistable attribtes to be added' do
    class Post
      persists :author
    end

    Post.attributes.should include(:title)
    Post.attributes.should include(:text)
    Post.attributes.should include(:author)
  end

  it 'should not leak attributes to other models' do
    class Post
      persists :author
    end

    Comment.attributes.should_not include(:title)
    Comment.attributes.should_not include(:author)
  end

end
