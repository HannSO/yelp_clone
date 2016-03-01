require 'rails_helper'

describe Restaurant, type: :model do
  it { is_expected.to have_many(:reviews).dependent(:destroy) }

  it 'is not valid unless it has 3 characters' do
    restaurant = Restaurant.new(name: 'kf')
    expect(restaurant).to have(1).error_on(:name)
    expect(restaurant).not_to be_valid
  end

  it 'is not valid unless it has a unique name' do
    Restaurant.create(name: 'Katsu Wrapper')
    restaurant = Restaurant.new(name: 'Katsu Wrapper')
    expect(restaurant).to have(1).error_on(:name)
  end
end
