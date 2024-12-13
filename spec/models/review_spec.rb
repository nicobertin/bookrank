# spec/models/review_spec.rb
require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  describe "validations" do
    it "is valid with a rating between 1 and 5" do
      review = build(:review, book: book, user: user, rating: 5, content: "Great book!")
      expect(review).to be_valid
    end

    it "is invalid with a rating less than 1" do
      review = build(:review, book: book, user: user, rating: 0)
      expect(review).not_to be_valid
    end

    it "is invalid with a rating greater than 5" do
      review = build(:review, book: book, user: user, rating: 6)
      expect(review).not_to be_valid
    end

    it "is invalid with content longer than 1000 characters" do
      long_content = "a" * 1001
      review = build(:review, book: book, user: user, rating: 4, content: long_content)
      expect(review).not_to be_valid
    end
  end
end