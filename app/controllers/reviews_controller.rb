class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book

  def create
    @review = @book.reviews.new(review_params)
    @review.user = @current_user

    if @review.save
      redirect_to @book, notice: "Review created successfully."
    else
      flash[:alert] = @review.errors.full_messages.join(", ")
      redirect_to @book
    end
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_review
    @review = @book.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end