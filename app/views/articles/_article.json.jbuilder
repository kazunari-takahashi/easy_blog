json.extract! article, :id, :title, :boxy, :draft, :created_at, :updated_at
json.url article_url(article, format: :json)
