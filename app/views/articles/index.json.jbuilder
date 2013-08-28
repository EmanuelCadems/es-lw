json.array!(@articles) do |article|
  json.extract! article, :title, :tags
  json.url article_url(article, format: :json)
end
