class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
  validates :body, maximum_length: { maximum: 10, cloumns: [:title] }
  # validate :maximum_length


  # private
  #
  #   def maximum_length
  #     unless (title + body).length > 10
  #       errors.add(:base, "件名とと本文合わせて10文字以上で入力してください")
  #     end
  #   end
end
