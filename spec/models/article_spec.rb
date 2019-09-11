require 'rails_helper'

RSpec.describe Article, type: :model do
  it do
    article = Article.new(body: "本文")
    article.valid?
  end
end
