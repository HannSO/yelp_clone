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
  context 'logged in user' do
    scenario 'allows users to leave a review using a form' do
       visit '/restaurants'
       click_link 'Review KFC'
       fill_in "Thoughts", with: "so so"
       select '3', from: 'Rating'
       click_button 'Leave Review'

       expect(current_path).to eq '/restaurants'
       expect(page).to have_content('so so')
    end
    scenario 'logged in can delete their own review' do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
      expect(page).to have_content('so so')
      click_link 'Delete review of KFC'
      expect(page).not_to have_content('so so')
    end
  end

  context 'logged in user already added a review' do
    before do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "so so"
      select '3', from: 'Rating'
      click_button 'Leave Review'
    end

    scenario 'user tries to add a second review and is prevented from doing so' do
      visit '/restaurants'
      click_link 'Review KFC'
      fill_in "Thoughts", with: "I LOVE KFC"
      select '5', from: 'Rating'
      click_button 'Leave Review'

      expect(page).to have_content('Restaurant already reviewed')
      expect(page).not_to have_content('I LOVE KFC')
    end
  end

  context 'no one logged in' do

    scenario 'logged out user tries to leave a review' do
      visit  '/restaurants'
      click_link('Sign out')
      click_link 'Review KFC'

      expect(page).to have_content('Log in')
      expect(page).not_to have_content('Leave Review')
    end
  end
end
