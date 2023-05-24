# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Welcome Page', type: :feature do
  before(:each) do
    @user_1 = User.create!(name: 'John Doe', email: 'johndoe@yahoo.com', password: 'password123', password_confirmation: 'password123')
    @user_2 = User.create!(name: 'Alex Smith', email: 'Asmith@yahoo.com', password: 'password123', password_confirmation: 'password123')
    @user_3 = User.create!(name: 'Elvis Presley', email: 'kingofrock@yahoo.com', password: 'password123', password_confirmation: 'password123')
    visit root_path
  end

  describe 'Landing Pages #3' do
    it 'exists' do
      expect(current_path).to eq(root_path)
    end

    it 'displays title of application' do
      within('#header') do
        expect(page).to have_content('Viewing Party')
      end
    end

    it 'displays button to create a new user' do
      within('#button') do
        expect(page).to have_button('Create a New User')
      end
    end

    it 'displays a list of existing users' do
      user1 = User.create!(name: 'Joe Bob', email: 'bigbobby@gmail.com', password: 'password123', password_confirmation: 'password123')

      visit root_path
      click_button 'Log In'
      fill_in :email, with: user1.email
      fill_in :password, with: 'password123'
      click_button 'Log In'
      click_link 'Home'

      within('#existing-users') do
        expect(page).to have_content('Existing Users')
        expect(page).to have_content(@user_1.email)
        expect(page).to have_content(@user_2.email)
        expect(page).to have_content(@user_3.email)
      end
    end

    it 'displays a link to go back to landing page' do
      expect(page).to have_link('Home')
      click_link('Home')
      expect(current_path).to eq(root_path)
    end
  end

  describe 'Authentication Challenge - User Story #3' do
    it 'has a button to log in' do
      visit root_path

      within('#button-2') do
        expect(page).to have_button('Log In')
      end
    end

    it 'when I click the button I am taken to a login page' do
      visit root_path

      within('#button-2') do
        click_button 'Log In'
      end

      expect(current_path).to eq(login_path)
    end
  end

  describe 'Authorization Challenge - Sessions' do
    it 'As a logged in user when I visit the landing page I no longer see a link to Log In or Create an Account' do
      user1 = User.create!(name: 'Joe Bob', email: 'bigbobby@gmail.com', password: 'password123', password_confirmation: 'password123')

      visit root_path
      click_button 'Log In'
      fill_in :email, with: user1.email
      fill_in :password, with: 'password123'
      click_button 'Log In'
      click_link 'Home'

      expect(current_path).to eq(root_path)
      expect(page).to_not have_button('Log In')
      expect(page).to_not have_button('Create a New User')
      expect(page).to have_button('Log Out')
    end

    it 'As a logged in user when I click the link to Log Out I am taken to the landing page' do
      user1 = User.create!(name: 'Joe Bob', email: 'bigbobby@gmail.com', password: 'password123', password_confirmation: 'password123')

      visit root_path
      click_button 'Log In'
      fill_in :email, with: user1.email
      fill_in :password, with: 'password123'
      click_button 'Log In'
      click_link 'Home'
      click_button 'Log Out'

      expect(current_path).to eq(root_path)
      expect(page).to have_button('Log In')
      expect(page).to have_button('Create a New User')
      expect(page).to_not have_button('Log Out')
    end
  end

  describe 'Authorization Challenge - User Story #1' do
    it 'As a visitor when I visit the landing page I do not see the section of the page that lists existing users' do
      visit root_path

      expect(page).to_not have_content('Existing Users')
    end
  end

  describe 'Authorization Challenge - User Story #2' do
    it 'As a registered user when I visit the landing page the list of existing users is no longer a link to their show pages but just a list of email addresses' do
      user1 = User.create!(name: 'Joe Bob', email: 'bigbobby@gmail.com', password: 'password123', password_confirmation: 'password123')
      user2 = User.create!(name: 'John Doe', email: 'johndiddy@gmail.com', password: 'password123', password_confirmation: 'password123')

      visit root_path
      click_button 'Log In'
      fill_in :email, with: user1.email
      fill_in :password, with: 'password123'
      click_button 'Log In'
      click_link 'Home'

      within('#existing-users') do
        expect(page).to have_content('Existing Users')
        expect(page).to have_content(user1.email)
        expect(page).to have_content(user2.email)
        expect(page).to_not have_link(user1.email)
        expect(page).to_not have_link(user2.email)
      end
    end
  end

  describe 'Authorization Challenge - User Story #3' do
    it 'As a visitor when I visit the user show page I remain on the landing page' do
      user1 = User.create!(name: 'Joe Bob', email: 'bigbobby@gmail.com', password: 'password123', password_confirmation: 'password123')

      visit root_path
      visit dashboard_path

      expect(current_path).to eq(root_path)
    end

    it 'And I see a message telling me that I must be logged in or registered to access my dashboard' do
      user1 = User.create!(name: 'Joe Bob', email: 'bigbobby@gmail.com', password: 'password123', password_confirmation: 'password123')

      visit root_path
      visit dashboard_path

      expect(page).to have_content('You must be logged in or registered to access your dashboard')
    end
  end
end

# As a visitor
# When I visit the landing page
# And then try to visit '/dashboard'
# I remain on the landing page
# And I see a message telling me that I must be logged in or registered to access my dashboard


