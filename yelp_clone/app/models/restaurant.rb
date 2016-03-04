class Restaurant < ActiveRecord::Base
  validates :name, length: {minimum: 3}, uniqueness: true
  has_many :reviews, dependent: :destroy
  belongs_to :user

  def average_rating
    # return 'N/A' if reviews.none?
    # man = reviews.inject(0){|memo, review| memo + review.rating}
    # man/reviews.countaa
    reviews.average(:rating)
  end

  def average_rating
   return 'N/A' if reviews.none?
   (reviews.inject(0) {|memo, review| memo + review.rating} / reviews.length)
  end
end
