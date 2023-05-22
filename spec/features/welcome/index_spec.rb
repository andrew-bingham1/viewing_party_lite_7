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
end
