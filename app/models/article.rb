class Article < ActiveRecord::Base
  before_save :add_to_es

  def add_to_es
    index = Tire.index 'articles'
    index.store type: self.class.name.downcase, title: title, tags: tags, created_at: created_at
  end

end
