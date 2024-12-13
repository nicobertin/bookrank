# spec/models/book_spec.rb
require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:user) { create(:user, email: "user@example.com") }
  let(:banned_user) { create(:user, email: "banned@example.com", banned: true) }

  describe "validations" do
    it "is valid with a unique title" do
      book = build(:book, title: "Unique Title")
      expect(book).to be_valid
    end

    it "is invalid without a title" do
      book = build(:book, title: nil)
      expect(book).not_to be_valid
    end

    it "is invalid with a duplicate title" do
      create(:book, title: "Duplicate Title")
      book = build(:book, title: "Duplicate Title")
      expect(book).not_to be_valid
    end
  end

  describe "#average_rating" do
    context "with valid reviews" do
      it "calculates the average rating with one decimal place" do
        book = create(:book, title: "Sample Book")
        create(:review, book: book, user: user, rating: 4, content: "Good book")
        create(:review, book: book, user: user, rating: 5, content: "Excellent book")
        create(:review, book: book, user: user, rating: 3, content: "Average book")

        expect(book.average_rating).to eq(4.0)
      end

      it "returns 'Insufficient Reviews' if there are less than 3 valid reviews" do
        book = create(:book, title: "Sample Book")
        create(:review, book: book, user: user, rating: 5, content: "Great book")
        create(:review, book: book, user: user, rating: 4, content: "Good book")

        expect(book.average_rating).to eq("Insufficient Reviews")
      end
    end

    context "with reviews from banned users" do
      it "does not count reviews from banned users" do
        book = create(:book, title: "Sample Book")
        create(:review, book: book, user: user, rating: 4, content: "Good book")
        create(:review, book: book, user: banned_user, rating: 5, content: "Banned user's review")

        expect(book.average_rating).to eq("Insufficient Reviews")
      end
    end

    context "with no reviews" do
      it "returns 'Insufficient Reviews' if there are no reviews" do
        book = create(:book, title: "Sample Book")

        expect(book.average_rating).to eq("Insufficient Reviews")
      end
    end
  end
end