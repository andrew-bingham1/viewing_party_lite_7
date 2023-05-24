require 'rails_helper'

RSpec.describe 'Movies Details Page', type: :feature do
  describe 'User Story #10', :vcr do
    before (:each) do
      @user1 = User.create!(name: 'John Doe', email: 'johndoe@yahoo.com', password: 'password123', password_confirmation: 'password123')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    end

    it 'exists' do
      visit user_movie_path(@user1, 238)

      expect(current_path).to eq(user_movie_path(@user1, 238))
    end

    it 'displays button to create viewing party' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
      visit user_movie_path(@user1, 238)
      expect(page).to have_button('Create Viewing Party')
      click_button 'Create Viewing Party'
      expect(current_path).to eq(user_new_viewing_party_path(@user1, 238))
    end

    it "displays a button to return to discover page" do
      visit user_movie_path(@user1, 238)
      expect(page).to have_button('Discover Page')
      click_button 'Discover Page'
      expect(current_path).to eq(discover_path)
    end

    it 'displays movie title' do
      visit user_movie_path(@user1, 100)

      within('#title') do
        expect(page).to have_content('Lock, Stock and Two Smoking Barrels')
        expect(page).to_not have_content('The Godfather')
      end
    end

    it 'shows movies info (vote average, runtime, genres)' do
      visit user_movie_path(@user1, 100)

      within('#movie-info') do
        expect(page).to have_content('Vote: 8.1')
        expect(page).to have_content('Runtime: 1 hour(s) and 45 minutes')
        expect(page).to have_content('Genre(s): Comedy Crime')
        expect(page).to_not have_content('Vote: 8.7')
        expect(page).to_not have_content('Runtime: 2 hour(s) and 55 minutes')
        expect(page).to_not have_content('Genre(s): Drama Crime')
      end
    end

    it 'shows movies summary' do
      visit user_movie_path(@user1, 238)

      within('#summary') do
        expect(page).to have_content('Summary:')
        expect(page).to have_content('Spanning the years 1945 to 1955')
        expect(page).to_not have_content('A card shark and his unwillingly-enlisted friends')
      end
    end

    it 'shows cast members' do
      visit user_movie_path(@user1, 238)

      within('#cast') do
        expect(page).to have_content('Cast:')
        expect(page).to have_content('Marlon Brando')
        expect(page).to have_content('Al Pacino')
        expect(page).to have_content('James Caan')
        expect(page).to have_content('Robert Duvall')
        expect(page).to have_content('Diane Keaton')
        expect(page).to_not have_content('Jason Flemyng')
        expect(page).to_not have_content('Dexter Fletcher')
        expect(page).to_not have_content('Nick Moran')
        expect(page).to_not have_content('Jason Statham')
        expect(page).to_not have_content('Steven Mackintosh')
      end
    end

    it 'shows reviews' do
      visit user_movie_path(@user1, 100)

      within('#reviews') do
        expect(page).to have_content('4 Reviews:')
        expect(page).to have_content('Reviewer: BradFlix')
        expect(page).to have_content('I just plain love this movie!')
        expect(page).to_not have_content('Reviewer: futuretv')
        expect(page).to_not have_content('The Godfather Review by Al Carlson')
      end
    end
  end

  # describe 'Authorization Challenge - User Story #4', :vcr do
  #   it 'As a visitor, if I go to a movies show page and click the button to create a viewing party, I am redirected to the movies show page, and a message appears to let me know I must be logged in or registered to create a movie party' do
  #     @user1 = User.create!(name: 'John Doe', email: 'johndoe@yahoo.com', password: 'password123', password_confirmation: 'password123')
  #     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
  #     visit user_movie_path(@user1, 238)
  #     click_button 'Create Viewing Party'
      
  #     expect(page).to have_content('You must be logged in to create a viewing party')
  #   end
  # end
end

