class ReviewsController < ApplicationController
  before_action :authenticate_user!
  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = @restaurant.reviews.create(review_params)

    if @review.save
      redirect_to restaurants_path
    elsif @review.errors[:user]
      redirect_to restaurants_path, alert: 'Restaurant already reviewed'
    end
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating).merge(user: current_user)
  end

  def destroy
    @review = Review.find(params[:id])
    if current_user.reviews.include?(@review)
      @review.destroy
      # if @review.owned_by?(current_user)
      #   @review.destroy
      flash[:notice] = "Review deleted"
    else
      flash[:notice] = "Cannot delete review you have not added"
    end
      redirect_to restaurants_path
  end
end
