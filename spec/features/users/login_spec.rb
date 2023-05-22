require 'rails_helper'

RSpec.describe 'Login Page', type: :feature do
  describe "It can log in" do
    it "happy path" do
      user = User.create!(name: 'John Doe', email: 'Johndoe@gmail.com', password: 'password123', password_confirmation: 'password123')
      visit login_path
      

      fill_in :email, with: user.email
      fill_in :password, with: user.password

      click_on "Log In"

      expect(current_path).to eq(user_path(user))

      expect(page).to have_content("Welcome, #{user.name}!")

    end

    it "sad path" do
      user = User.create!(name: 'John Doe', email: 'Johndoe@gmail.com', password: 'password123', password_confirmation: 'password123')
      visit login_path
      

      fill_in :email, with: user.email
      fill_in :password, with: "incorrect password"

      click_on "Log In"

      expect(current_path).to eq(login_path)

      expect(page).to have_content("Sorry, your credentials are bad.")
    end
  end
end