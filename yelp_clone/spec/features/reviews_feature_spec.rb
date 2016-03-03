require 'rails_helper'

def leave_review_KFC(thoughts, rating)
  visit '/restaurants'
  click_link 'Review KFC'
  fill_in 'Thoughts', with: thoughts
  select rating, from: 'Rating'
  click_button 'Leave Review'
end


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
       leave_review_KFC('So so', '3')
       expect(current_path).to eq '/restaurants'
       expect(page).to have_content('So so')
    end
    scenario 'logged in can delete their own review' do
      leave_review_KFC('so so', '3')
      expect(page).to have_content('so so')
      click_link 'Delete review of KFC'
      expect(page).not_to have_content('so so')
    end
  end

  context 'logged in user already added a review' do
    before do
      leave_review_KFC('so so', '3')
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

  context 'someone else has left a review; diff user logged in' do
    before do
      leave_review_KFC('so so', '3')
      click_link('Sign out')
      visit '/users/sign_up'
      fill_in('Email', with: 'test2@example.com')
      fill_in('Password', with: 'test2test')
      fill_in('Password confirmation', with: 'test2test')
      click_button('Sign up')
    end

    scenario 'diff user logs in and leaves review, creating average' do

      leave_review_KFC('EXCELLENT!', '5')
      expect(page).to have_content('Average rating: 4')
    end
  end
end
