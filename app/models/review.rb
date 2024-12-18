class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :content, length: { maximum: 1000 }

  after_create :moderate_content

  private

  def moderate_content
    ReviewModerationJob.perform_later(self.id)
  end
end