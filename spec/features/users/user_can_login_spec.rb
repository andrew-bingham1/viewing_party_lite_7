require 'rails_helper'

RSpec.describe 'Login Page', type: :feature do
  before(:each) do
    @user1 = User.create!(name: 'John Doe', email: 'johndoe@yahoo.com', password: 'password123', password_confirmation: 'password123')
  end

  it 'exists' do 
    visit root_path

    click_button 'Log In'

    expect(current_path).to eq(login_path)
  end

  it 'can log in a user' do
    visit login_path

    fill_in :email, with: @user1.email
    fill_in :password, with: 'password123'

    click_button 'Log In'

    expect(current_path).to eq(dashboard_path)
  end

  it 'will display an error message email is invalid' do
    visit login_path

    fill_in :email, with: 'anotherrandomdude@gmail.com'
    fill_in :password, with: 'password123'

    click_button 'Log In'

    expect(current_path).to eq(login_path)
    expect(page).to have_content('Sorry, that email is invalid')
  end

  it 'will display an error message if password is incorrect' do
    visit login_path

    fill_in :email, with: @user1.email
    fill_in :password, with: 'password1234'

    click_button 'Log In'

    expect(current_path).to eq(login_path)
    expect(page).to have_content('Sorry, that password is incorrect')
  end
end