class ArticleSearchQuery
  include ActiveModel::Model
  attr_writer :title
  attr_accessor :from_date, :to_date

  def articles
    scope = Article.all
    scope = scope.where(conditions.join(" AND "), values) if conditions.count.nonzero?
    scope
  end

  def title
    "%#{Article.sanitize_sql_like(@title)}%" unless @title.blank?
  end

  private

    def conditions
      result = []
      result << "title like :title" if title
      result << "created_at >= :from_date" if from_date
      result << "created_at <= :to_date" if to_date
      result
    end

    def values
      { from_date: from_date, to_date: to_date, title: title }
    end
end
