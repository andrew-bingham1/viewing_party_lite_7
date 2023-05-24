require 'rails_helper'

RSpec.describe 'User Show Page', type: :feature do
  before(:each) do
    @user_1 = User.create!(name: 'John Doe', email: 'johndoe@yahoo.com', password: 'password123', password_confirmation: 'password123')
    @user_2 = User.create!(name: 'Alex Smith', email: 'Asmith@yahoo.com', password: 'password123', password_confirmation: 'password123')
    @user_3 = User.create!(name: 'Elvis Presley', email: 'kingofrock@yahoo.com', password: 'password123', password_confirmation: 'password123')

    @viewing_party_1 = ViewingParty.create!(movie_id: 100, duration: 175, date: '2021-08-01', start_time: '19:00:00 UTC', user_id: @user_1.id)
    @viewing_party_2 = ViewingParty.create!(movie_id: 238, duration: 145, date: '2020-06-11', start_time: '14:00:00 UTC', user_id: @user_2.id)

   
    @viewing_party_user_2 = ViewingPartyUser.create!(user_id: @user_2.id, viewing_party_id: @viewing_party_1.id)
    @viewing_party_user_3 = ViewingPartyUser.create!(user_id: @user_3.id, viewing_party_id: @viewing_party_1.id)
    
    @viewing_party_user_4 = ViewingPartyUser.create!(user_id: @user_1.id, viewing_party_id: @viewing_party_2.id)
    @viewing_party_user_5 = ViewingPartyUser.create!(user_id: @user_3.id, viewing_party_id: @viewing_party_2.id)
    visit user_path(@user_1)
  end

  describe "User Dashboard #5", :vcr do
    it "displays <User Name>'s Dashboard" do
      within("#user-dashboard") do
        expect(page).to have_content("John Doe's Dashboard")
      end
    end
    it "displays a button 'Discover Movies' " do
      within("#user-dashboard") do
        expect(page).to have_button("Discover Movies")
      end
    end
    it "displays a section that lists viewing parties" do 
      visit user_path(@user_1)

      within("#user-viewing-parties") do
        expect(page).to have_selector("#image")
        expect(page).to have_content("Lock, Stock and Two Smoking Barrels")
        expect(page).to have_content("Hosting")

        expect(page).to have_content("The Godfather")
        expect(page).to have_content("Invited")
      end
    end
  end

  describe "Dashboard:Discover Movies #6", :vcr do
    it "clicking 'Discover Movies' redirects to user_discover_index_path " do
      within("#user-dashboard") do
        click_button("Discover Movies")
        expect(current_path).to eq(user_discover_path(@user_1))
      end
    end
  end

  describe "Dashboard: Viewing Parties#12", :vcr do
    it "displays a section that lists viewing parties" do
      expect(page).to have_selector("#user-viewing-parties")
    end

    it "displays image, title, date, time, host, and invited friends to invited parties" do
      within("#user-viewing-parties") do
        expect(page).to have_selector("#image")
        expect(page).to have_content("The Godfather")
        expect(page).to have_content("June 11, 2020")
        expect(page).to have_content("2:00 PM")
        expect(page).to have_content("Invited")
        expect(page).to have_content("Host: Alex Smith")
        expect(page).to have_content("Invited: John Doe Elvis Presley")
      end
    end

    it "displays image, title, date, time, host, and invited friends to hosted parties" do
      within("#user-viewing-parties") do
        expect(page).to have_selector("#image")
        expect(page).to have_content("Lock, Stock and Two Smoking Barrels")
        expect(page).to have_content("August 1, 2021")
        expect(page).to have_content("7:00 PM")
        expect(page).to have_content("Hosting")
        expect(page).to have_content("Alex Smith and Elvis Presley")
      end
    end

    it "movie title links to movie show page" do
      within("#user-viewing-parties") do
        click_link("The Godfather")
        expect(current_path).to eq(user_movie_path(@user_1, 238))
      end
    end
  end
end
