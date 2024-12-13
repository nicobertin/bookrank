class Book < ApplicationRecord
  has_many :reviews

  validates :title, presence: true, uniqueness: true

  def average_rating
    return "Insufficient Reviews" unless has_enough_reviews?

    average = valid_reviews.sum(:rating).to_f / valid_reviews.size
    average.round(1)
  end

  def has_enough_reviews?
    valid_reviews.size >= 3
  end

  private

  def valid_reviews
    reviews.joins(:user).where(users: { banned: false })
  end
end
