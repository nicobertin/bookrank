require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:book) { create(:book) }

  describe "POST #create" do
    context "when the user is logged in" do
      before { login_user(user) }

      context "with valid parameters" do
        let(:valid_params) { { book_id: book.id, review: attributes_for(:review) } }

        it "creates a new review" do
          expect { post :create, params: valid_params }.to change(Review, :count).by(1)
        end

        it "redirects to the book page with a success notice" do
          post :create, params: valid_params
          expect(response).to redirect_to(book)
          expect(flash[:notice]).to eq("Review created successfully.")
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) { { book_id: book.id, review: { rating: 6, content: 'Invalid rating' } } }

        it "does not create a new review" do
          expect { post :create, params: invalid_params }.not_to change(Review, :count)
        end

        it "redirects to the book page with an error message" do
          post :create, params: invalid_params
          expect(response).to redirect_to(book)
          expect(flash[:alert]).to include("Rating is not included in the list")
        end
      end
    end

    context "when the user is not logged in" do
      it "redirects to the login page" do
        post :create, params: { book_id: book.id, review: { rating: 4, content: 'Nice read' } }
        expect(response).to redirect_to(users_login_path)
        expect(flash[:alert]).to eq("You must be logged in to access this page.")
      end
    end
  end
end