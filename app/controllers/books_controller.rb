class BooksController < ApplicationController
  before_action :authenticate_user!

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    @reviews = @book.reviews.includes(:user).where(users: { banned: false }).order(created_at: :desc)
  end
end
