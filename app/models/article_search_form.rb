class ArticleSearchForm
  include ActiveModel::Model
  attr_accessor :title
  attr_writer :from_date, :to_date

  validates :title, length: { maximum: 10 }, allow_blank: true
  validate :ensure_from_date, :ensure_to_date

  def articles
    if valid?
      article = Article.all
      article = article.where("title like ?", "%#{title}%") unless title.blank?
      article = article.where(created_at: from_date..to_date) unless from_date.blank? && to_date.blank?
      article
    else
      Article.all
    end
  end

  def from_date
    @from_date&.to_time
  rescue ArgumentError
    nil
  end

  def to_date
    @to_date&.to_time
  rescue ArgumentError
    nil
  end

  private

    def ensure_from_date
      ensure_date(@from_date, :from_date)
    end

    def ensure_to_date
      ensure_date(@to_date, :to_date)
    end

    def ensure_date(date, symbol)
      return false if date.blank?

      unless date.match(/\A\d{4}-\d{2}-\d{2}\z/)
        errors.add(symbol, "日時の書式に誤りがあります")
      end
    end
end
