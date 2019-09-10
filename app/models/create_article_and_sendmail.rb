class CreateArticleAndSendmail
  include ActiveModel::Model
  define_model_callbacks :save, only: :after
  after_save :send_mail

  def initialize(article)
    @article = article
  end

  def save
    run_callbacks :save do
      @article.save
    end
  end

  private

    def send_mail
      ArticleMailer.new_article(@article).deliver_now
    end
end
