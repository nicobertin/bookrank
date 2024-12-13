# spec/requests/reviews_spec.rb
require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let!(:user) { create(:user, email: "test@example.com", password: "password") }
  let!(:book) { create(:book, title: "Sample Book") }

  before { login_user_request(user) }

  describe "POST /books/:book_id/reviews" do
    context "with valid parameters" do
      let(:valid_params) do
        { review: { rating: 5, content: "Excellent book!" } }
      end

      it "creates a new review" do
        expect {
          post book_reviews_path(book), params: valid_params
        }.to change(Review, :count).by(1)
      end

      it "redirects to the book page with a success notice" do
        post book_reviews_path(book), params: valid_params
        expect(response).to redirect_to(book_path(book))
        follow_redirect!
        expect(response.body).to include("Review created successfully.")
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        { review: { rating: nil, content: "This book is okay." } }
      end

      it "does not create a new review" do
        expect {
          post book_reviews_path(book), params: invalid_params
        }.not_to change(Review, :count)
      end

      it "redirects to the book page with an error message" do
        post book_reviews_path(book), params: invalid_params
        expect(response).to redirect_to(book_path(book))
        follow_redirect!
        expect(response.body).to match(/Rating can't be blank|Rating is not included in the list/)
      end
    end
  end
end