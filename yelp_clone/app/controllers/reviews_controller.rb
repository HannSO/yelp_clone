class ReviewsController < ApplicationController
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
    params.require(:review).permit(:thoughts, :rating)
  end
end





# if current_user.has_reviewed? @restaurant
#   flash[:notice] = 'Restaurant already reviewed'
# end
