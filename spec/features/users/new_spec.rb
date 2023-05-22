require 'rails_helper'

RSpec.describe 'Registration Page', type: :feature do
  describe 'User Story #4' do
    it 'exists' do
      visit root_path

      click_button 'Create a New User'

      expect(current_path).to eq(register_path)
    end

    it 'can create a new user' do
      visit register_path

      within('#new-user-form') do
        fill_in 'Name', with: 'John Doe'
        fill_in 'Email', with: 'johndoe@yahoo.com'
        fill_in :password, with: 'password123'
        fill_in :password_confirmation, with: 'password123'
        click_button 'Create New User'
      end

      expect(current_path).to eq(user_path(User.last))
    end

    it 'will display an error message if name is left blank' do
      visit register_path

      within('#new-user-form') do
        fill_in 'Email', with: 'johndoe@yahoo.com'
        click_button 'Create New User'
      end

      expect(current_path).to eq(register_path)
      expect(page).to have_content('Name must be filled out')
    end

    it 'will display an error message if email is left blank' do
      visit register_path

      within('#new-user-form') do
        fill_in 'Name', with: 'John Doe'
        click_button 'Create New User'
      end

      expect(current_path).to eq(register_path)
      expect(page).to have_content('Email must be filled out')
    end

    it 'will display an error message if email is already taken' do
      user1 = User.create!(name: 'John Doe', email: 'johndoe@yahoo.com', password: 'password123', password_confirmation: 'password123')

      visit register_path

      within('#new-user-form') do
        fill_in 'Name', with: 'John Doe'
        fill_in 'Email', with: 'johndoe@yahoo.com'
        fill_in :password, with: 'password123'
        fill_in :password_confirmation, with: 'password123'
        click_button 'Create New User'
      end

      expect(current_path).to eq(register_path)
      expect(page).to have_content('Email is already taken')
    end

    it 'will display multiple error messages if both fields are left blank' do
      visit register_path

      within('#new-user-form') do
        click_button 'Create New User'
      end

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Name must be filled out, Email must be filled out, Password digest can't be blank, and Password can't be blank")
    end
  end
end
