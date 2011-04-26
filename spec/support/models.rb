
class Article
  include Datapathy::Model
  def self.adapter
    Datapathy.adapters[:memory]
  end

  persists :title, :text, :published_at

  def summary
    text[0,30]
  end

  # used to test querying on a method
  def has_title?(title)
    self.title == title
  end

end

class Person
  include Datapathy::Model
  def self.adapter
    Datapathy.adapters[:memory]
  end

  persists :name

  validates_presence_of :name

end
