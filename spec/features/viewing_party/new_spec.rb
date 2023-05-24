require 'rails_helper'

RSpec.describe 'New Viewing Party Page', type: :feature do
  describe 'New Viewing Party Page #11', :vcr do
    before :each do
      @user_1 = User.create!(name: 'John Doe', email: 'johndoe@yahoo.com', password: 'password123', password_confirmation: 'password123')
      @user_2 = User.create!(name: 'Alex Smith', email: 'Asmith@yahoo.com', password: 'password123', password_confirmation: 'password123')
      @user_3 = User.create!(name: 'Elvis Presley', email: 'kingofrock@yahoo.com', password: 'password123', password_confirmation: 'password123')
      @user_4 = User.create!(name: 'John Lennon', email: 'JLJL@yahoo.com', password: 'password123', password_confirmation: 'password123')

      visit  user_new_viewing_party_path(@user_1, 238)
    end
    describe "Happy Path" do
      it "displays movie title" do
        expect(page).to have_content("The Godfather")
      end
      it "has fields for duration of party, date, start time" do
        expect(page).to have_field("duration")
        expect(page).to have_field("date")
        expect(page).to have_field("start_time")
      end

      it "has checkboxes for each existing user" do
        within("#user-#{@user_2.id}") do
          expect(page).to have_content("Alex Smith")
          expect(page).to have_unchecked_field
        end
        within("#user-#{@user_3.id}") do
          expect(page).to have_content("Elvis Presley")
          expect(page).to have_unchecked_field
        end
        within("#user-#{@user_4.id}") do
          expect(page).to have_content("John Lennon")
          expect(page).to have_unchecked_field
        end
      end

      it "has a button to create a party" do
        expect(page).to have_button("Create Party")
      end

      it "redirects to dashboard when party is created" do
        fill_in "duration", with: 175
        fill_in "date", with: "2021-07-01"
        fill_in "start_time", with: "19:00"
        all(:checkbox)[0].check
        all(:checkbox)[1].check
        all(:checkbox)[2].check
        click_button "Create Party"
        expect(current_path).to eq(user_path(@user_1))
      end

      it "shows new event on dashboard" do
        fill_in "duration", with: 175
        fill_in "date", with: "2021-07-01"
        fill_in "start_time", with: "19:00"
        all(:checkbox)[0].check
        all(:checkbox)[1].check
        all(:checkbox)[2].check
        click_button "Create Party"

        within("#user-viewing-parties") do
          expect(page).to have_content("The Godfather")
          expect(page).to have_content("July 1, 2021")
          expect(page).to have_content("7:00 PM")
          expect(page).to have_content("Hosting")
          expect(page).to have_content("Alex Smith, Elvis Presley, and John Lennon")
        end
      end
    end
    describe "Sad Path" do
      it "raises error if any fields are missing" do
        fill_in "duration", with: ""
        fill_in "date", with: ""
        fill_in "start_time", with: ""
        all(:checkbox)[0].check
        all(:checkbox)[1].check
        all(:checkbox)[2].check
        click_button "Create Party"
        expect(current_path).to eq(user_new_viewing_party_path(@user_1, 238))
        expect(page).to have_content("Date can't be blank, Start time can't be blank, and Duration can't be blank")
      end
      it "raises error if no users are selected" do
        fill_in "duration", with: 175
        fill_in "date", with: "2021-07-01"
        fill_in "start_time", with: "19:00"
        click_button "Create Party"
        expect(current_path).to eq(user_new_viewing_party_path(@user_1, 238))
        expect(page).to have_content("You must select at least one friend to invite")
      end
    end
  end
end