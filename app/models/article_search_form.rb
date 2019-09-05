class ArticleSearchForm
  include ActiveModel::Model

  attr_accessor :title
  attr_writer :from_date, :to_date
  validates :title, length: { maximum: 50 }, allow_blank: true
  validate :ensure_to_date_format, :ensure_from_date_format

  def articles
    if valid?
      ArticleSearchQuery.new(params).articles
    else
      Article.all
    end
  end

  def from_date
    @from_date&.to_datetime
  rescue ArgumentError
    nil
  end

  def to_date
    @to_date&.to_datetime
  rescue ArgumentError
    nil
  end

  private

    def ensure_date_format(time)
      return false if time.blank?

      !!time.match(/\A\d{4}-\d{2}-\d{2}\z/)
    end

    def ensure_to_date_format
      ensure_date_format(@to_date)
    end

    def ensure_from_date_format
      ensure_date_format(@from_date)
    end

    def params
      { title: title, to_date: to_date, from_date: from_date }
    end
end
