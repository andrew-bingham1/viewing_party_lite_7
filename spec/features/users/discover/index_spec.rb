require 'rails_helper'

RSpec.describe 'Discover Movies Page', type: :feature do
  before(:each) do
    @user1 = User.create!(name: 'John Doe', email: 'johndoe@yahoo.com', password: 'password123', password_confirmation: 'password123')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
  end
  describe 'User Story #8',:vcr do

    it 'exists' do
      visit discover_path

      expect(current_path).to eq(discover_path)
    end

    it 'has a button to discover top 20 movies' do
      visit discover_path

      within('#find-movies-button') do
        expect(page).to have_button('Find Top Rated Movies')
      end
    end

    it 'takes user to movies index with top 20 movies when button is clicked' do
      visit discover_path

      within('#find-movies-button') do
        click_button 'Find Top Rated Movies'
      end

      expect(current_path).to eq(movies_path)
      
      within('#movies') do
        expect(page).to have_content('The Godfather')
      end
    end

    it 'has a button to discover movies by search' do
      visit discover_path

      within('#movie-search') do
        expect(page).to have_field('movie_title')
        expect(page).to have_button('Find Movies')
      end
    end

    it 'takes user to movies index with movies by keyword when button is clicked' do
      visit discover_path

      within('#movie-search') do
        fill_in 'movie_title', with: 'Lock, Stock and Two Smoking Barrels'
        click_button 'Find Movies'
      end

      expect(current_path).to eq(movies_path)
      expect(page).to have_content('Lock, Stock and Two Smoking Barrels')
      expect(page).to_not have_content('The Godfather')
    end
  end

  describe "Movies Results Page #9", :vcr do
    it "clicking top movies takes user to movies result page" do
      visit discover_path
      click_button 'Find Top Rated Movies'
      expect(current_path).to eq(movies_path) 
    end

    it "displays title, vote average, for 20 movie" do
      visit discover_path
      click_button 'Find Top Rated Movies'
      within("#movies") do
        expect(page).to have_content("The Godfather\nVote Average: 8.7")
        expect(page).to have_content("The Shawshank Redemption\nVote Average: 8.7")
        expect(page).to have_content("Cuando Sea Joven\nVote Average: 8.6")
       
        expect(page).to have_content("The Godfather Part II\nVote Average: 8.6")
        expect(page).to have_content("Schindler's List\nVote Average: 8.6")
        expect(page).to have_content("Dilwale Dulhania Le Jayenge\nVote Average: 8.6")
        expect(page).to have_content("Spirited Away\nVote Average: 8.5")
        expect(page).to have_content("12 Angry Men\nVote Average: 8.5")
        expect(page).to have_content("Your Name.\nVote Average: 8.5")
        expect(page).to have_content("Parasite\nVote Average: 8.5")
        expect(page).to have_content("The Dark Knight\nVote Average: 8.5")
        expect(page).to have_content("The Green Mile\nVote Average: 8.5")
        expect(page).to have_content("Pulp Fiction\nVote Average: 8.5")
        expect(page).to have_content("The Good, the Bad and the Ugly\nVote Average: 8.5")
        expect(page).to have_content("Forrest Gump\nVote Average: 8.5")
        expect(page).to have_content("The Lord of the Rings: The Return of the King\nVote Average: 8.5")
        expect(page).to have_content("Dou kyu sei – Classmates\nVote Average: 8.5")
        expect(page).to have_content("The Boy, the Mole, the Fox and the Horse\nVote Average: 8.5")
        expect(page).to have_content("GoodFellas\nVote Average: 8.5")

        expect(page).to_not have_content("Shrek")
      end
    end

    it "filling search and clicking search takes user to movies result page" do
      visit discover_path
      fill_in 'movie_title', with: 'Lock, Stock and Two Smoking Barrels'
      click_button 'Find Movies'
      expect(current_path).to eq(movies_path) 
    end

    it "displays title, vote average, for first 20 movie" do
      visit discover_path
      fill_in 'movie_title', with: 'Lock, Stock and Two Smoking Barrels'
      click_button 'Find Movies'
      within("#movies") do
        expect(page).to have_content("Lock, Stock and Two Smoking Barrels Vote Average: 8.132")
        expect(page).to_not have_content("Shrek")
      end
    end

    it "has a button to return to discover page" do
      visit movies_path
      expect(page).to have_button("Discover Page")
    end

    it "returns to discover page when button is clicked" do
      visit movies_path
      click_button("Discover Page")
      expect(current_path).to eq(discover_path)
    end
  end
end