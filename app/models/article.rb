class Article < ActiveRecord::Base
  after_save :add_document
  after_destroy :remove_document

  acts_as_taggable

  def add_document
    index = Tire.index 'articles'
    index.store type: self.class.name.downcase, id: id, title: title,
      tags: tag_list, created_at: created_at, content: content
  end

  def remove_document
    Tire.index('articles').remove(self.class.name.downcase, id)
  end

  def self.search(params)
    s = Tire.search 'articles' do
          query do
            string "title:#{params[:query]}" if params[:query].present?
          end

          filter :terms, :tags => params[:filter_tags].split(',') if params[:filter_tags].present?

          facet 'global-tags', :global => true do
            terms :tags
          end

          facet 'current-tags' do
            terms :tags
          end
        end
  end

  def self.search_boolean(params)
    s = Tire.search 'articles' do
          query do
            boolean do
              should   { string "tags:#{params[:should]}" } if params[:should].present?
              must_not { string "tags:#{params[:must_not]}" } if params[:must_not].present?
            end
          end

          facet 'global-tags', :global => true do
            terms :tags
          end

          facet 'current-tags' do
            terms :tags
          end
        end
  end
end
