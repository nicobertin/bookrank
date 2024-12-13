class User < ApplicationRecord
  has_secure_password
  has_many :reviews, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }

  before_save :normalize_email

  private

  def normalize_email
    self.email = email.downcase.strip if email.present?
  end
end