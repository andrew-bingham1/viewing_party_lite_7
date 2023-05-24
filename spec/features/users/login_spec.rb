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

  describe "Admin login" do
    describe "happy path" do
      it "I can log in as an admin and get to my dashboard" do
        admin = User.create!(name: 'Super Admin', email: 'admin@gmail.com', password: 'test', password_confirmation: 'test', role: 2)
  
        visit login_path
        fill_in :email, with: admin.email
        fill_in :password, with: admin.password
        click_button "Log In"
  
        expect(current_path).to eq(admin_dashboard_path)
      end
    end
  end
  
  describe "as default user" do
    it 'does not allow default user to see admin dashboard index' do
      user = User.create!(name: 'Regular User', email: 'user@gmail.com', password: 'password123', password_confirmation: 'password123')
  
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  
      visit admin_dashboard_path
  
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end