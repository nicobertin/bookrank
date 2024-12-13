# spec/requests/books_spec.rb
require 'rails_helper'

RSpec.describe "Books", type: :request do
  let!(:user) { create(:user, email: 'user@example.com') }
  let!(:book) { create(:book, title: 'Sample Book') }

  describe "GET /index" do
    context "when the user is logged in" do
      before { login_user_request(user) }

      it "returns http success" do
        get books_path
        expect(response).to have_http_status(:success)
      end
    end

    context "when the user is not logged in" do
      it "redirects to the login page" do
        get books_path
        expect(response).to redirect_to(users_login_path)
        expect(flash[:alert]).to eq("You must be logged in to access this page.")
      end
    end
  end

  describe "GET /show" do
    context "when the user is logged in" do
      before { login_user_request(user) }

      it "returns http success" do
        get book_path(book)
        expect(response).to have_http_status(:success)
      end
    end

    context "when the user is not logged in" do
      it "redirects to the login page" do
        get book_path(book)
        expect(response).to redirect_to(users_login_path)
        expect(flash[:alert]).to eq("You must be logged in to access this page.")
      end
    end
  end
end