require 'rails_helper'

feature 'reviewing' do
  before do
    Restaurant.create name: 'KFC'
    visit '/users/sign_up'
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')

  end

  scenario 'allows users to leave a review using a form' do
     visit '/restaurants'
     click_link 'Review KFC'
     fill_in "Thoughts", with: "so so"
     select '3', from: 'Rating'
     click_button 'Leave Review'

     expect(current_path).to eq '/restaurants'
     expect(page).to have_content('so so')
  end

  scenario 'logged out user tries to leave a review' do
    visit  '/restaurants'
    click_link('Sign out')
    click_link 'Review KFC'

    expect(current_path).to eq '/users/sign_in'
    expect(page).to have_content('Log in')
    expect(page).not_to have_content('Leave Review')
  end
end
