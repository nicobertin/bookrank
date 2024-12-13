# spec/controllers/books_controller_spec.rb
require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  let!(:user) { create(:user, email: 'user@example.com') }
  let!(:book1) { create(:book, title: 'Sample Book 1') }
  let!(:book2) { create(:book, title: 'Sample Book 2') }

  describe "GET #index" do
    context "when the user is logged in" do
      before do
        login_user(user)
        get :index
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns all books to @books" do
        expect(assigns(:books)).to match_array([book1, book2])
      end

      it "renders the index template" do
        expect(response).to render_template(:index)
      end
    end

    context "when the user is not logged in" do
      before { get :index }

      it "redirects to the login page" do
        expect(response).to redirect_to(users_login_path)
        expect(flash[:alert]).to eq("You must be logged in to access this page.")
      end
    end
  end

  describe "GET #show" do
    context "when the user is logged in" do
      before do
        login_user(user)
        get :show, params: { id: book1.id }
      end

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "assigns the requested book to @book" do
        expect(assigns(:book)).to eq(book1)
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end

    context "when the user is not logged in" do
      before { get :show, params: { id: book1.id } }

      it "redirects to the login page" do
        expect(response).to redirect_to(users_login_path)
        expect(flash[:alert]).to eq("You must be logged in to access this page.")
      end
    end
  end
end