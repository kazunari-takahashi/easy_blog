class CreateArticleWithNotify
  include ActiveModel::Model

  define_model_callbacks :save, only: :after
  after_save :notify

  def initialize(article)
    @article = article
  end

  def save
    run_callbacks :save do
      @article.save
    end
  end

  private

    def notify
      ArticleMailer.new_article(@article).deliver_now
    end
end
