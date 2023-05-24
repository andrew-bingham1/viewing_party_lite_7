# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ViewingParty, type: :model do
  describe 'relationships' do
    it { should belong_to :user }
    it { should have_many :viewing_party_users }
    it { should have_many(:users).through(:viewing_party_users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:duration) }
    it { should validate_presence_of(:movie_id) }
    it { should validate_presence_of(:user_id) }
  end

  describe 'class methods', :vcr do
    before(:each) do
      @user_1 = User.create!(name: 'John Doe', email: 'johndoe@yahoo.com', password: 'password123', password_confirmation: 'password123')
      @user_2 = User.create!(name: 'Alex Smith', email: 'Asmith@yahoo.com', password: 'password123', password_confirmation: 'password123')
      @user_3 = User.create!(name: 'Elvis Presley', email: 'kingofrock@yahoo.com', password: 'password123', password_confirmation: 'password123')
      @user_4 = User.create!(name: 'Bob Dylan', email: 'bobbyboy@yahoo.com', password: 'password123', password_confirmation: 'password123')
      @user_5 = User.create!(name: 'Jimi Hendrix', email: 'spittinjimi@yahoo.com', password: 'password123', password_confirmation: 'password123')

      @viewing_party_1 = ViewingParty.create!(movie_id: 100, duration: 175, date: '2021-08-01', start_time: '2021-08-01 19:00:00 UTC', user_id: @user_1.id)
      @viewing_party_2 = ViewingParty.create!(movie_id: 202, duration: 145, date: '2020-06-11', start_time: '2021-06-011 14:00:00 UTC', user_id: @user_2.id)

      @viewing_party_user_1 = ViewingPartyUser.create!(user_id: @user_2.id, viewing_party_id: @viewing_party_1.id)
      @viewing_party_user_2 = ViewingPartyUser.create!(user_id: @user_3.id, viewing_party_id: @viewing_party_1.id)
      @viewing_party_user_3 = ViewingPartyUser.create!(user_id: @user_1.id, viewing_party_id: @viewing_party_2.id)
      @viewing_party_user_4 = ViewingPartyUser.create!(user_id: @user_3.id, viewing_party_id: @viewing_party_2.id)
      @viewing_party_user_5 = ViewingPartyUser.create!(user_id: @user_4.id, viewing_party_id: @viewing_party_2.id)
    end

    it "::find_hosted_parties" do
      output = ViewingParty.find_hosted_parties(@user_1)
      output_2 = ViewingParty.find_hosted_parties(@user_2)
      output_3 = ViewingParty.find_hosted_parties(@user_3)

      expect(output).to eq([@viewing_party_1])
      expect(output_2).to eq([@viewing_party_2])
      expect(output_3).to eq([])

      @viewing_party_3 = ViewingParty.create!(movie_id: 100, duration: 175, date: '2021-08-01', start_time: '2021-08-01 19:00:00 UTC', user_id: @user_3.id)

      output_4 = ViewingParty.find_hosted_parties(@user_3)

      expect(output_4).to eq([@viewing_party_3])

    end

    it "::find_invited_parties" do
      output = ViewingParty.find_invited_parties(@user_1)
      output_2 = ViewingParty.find_invited_parties(@user_2)
      output_3 = ViewingParty.find_invited_parties(@user_5)

      expect(output).to eq([@viewing_party_2])
      expect(output_2).to eq([@viewing_party_1])
      expect(output_3).to eq([])

      @viewing_party_user_6 = ViewingPartyUser.create!(user_id: @user_5.id, viewing_party_id: @viewing_party_2.id)

      output_4 = ViewingParty.find_invited_parties(@user_5)

      expect(output_4).to eq([@viewing_party_2])
    end
  end

  describe "instance methods", :vcr do
    before(:each) do
      @user_1 = User.create!(name: 'John Doe', email: 'johndoe@yahoo.com', password: 'password', password_confirmation: 'password')
      @user_2 = User.create!(name: 'Alex Smith', email: 'Asmith@yahoo.com', password: 'password', password_confirmation: 'password')
      @user_3 = User.create!(name: 'Elvis Presley', email: 'kingofrock@yahoo.com', password: 'password', password_confirmation: 'password')
      @user_4 = User.create!(name: 'Bob Dylan', email: 'bobbyboy@yahoo.com', password: 'password', password_confirmation: 'password')
      @user_5 = User.create!(name: 'Jimi Hendrix', email: 'spittinjimi@yahoo.com', password: 'password', password_confirmation: 'password')

      @viewing_party_1 = ViewingParty.create!(movie_id: 100, duration: 175, date: '2021-08-01', start_time: '2021-08-01 19:00:00 UTC', user_id: @user_1.id)
      @viewing_party_2 = ViewingParty.create!(movie_id: 238, duration: 145, date: '2020-06-11', start_time: '2021-06-011 14:00:00 UTC', user_id: @user_2.id)

      @viewing_party_user_1 = ViewingPartyUser.create!(user_id: @user_2.id, viewing_party_id: @viewing_party_1.id)
      @viewing_party_user_2 = ViewingPartyUser.create!(user_id: @user_3.id, viewing_party_id: @viewing_party_1.id)
      @viewing_party_user_3 = ViewingPartyUser.create!(user_id: @user_1.id, viewing_party_id: @viewing_party_2.id)
      @viewing_party_user_4 = ViewingPartyUser.create!(user_id: @user_3.id, viewing_party_id: @viewing_party_2.id)
      @viewing_party_user_5 = ViewingPartyUser.create!(user_id: @user_4.id, viewing_party_id: @viewing_party_2.id)
    end

    it "#poster" do
      result_1 = @viewing_party_1.poster(@viewing_party_1.movie_id)
    
      expect(result_1).to eq("/8kSerJrhrJWKLk1LViesGcnrUPE.jpg")

      result_2 = @viewing_party_2.poster(@viewing_party_2.movie_id)

      expect(result_2).to eq("/3bhkrj58Vtu7enYsRolD1fZdja1.jpg")
    end

    it "#title" do
      result_1 = @viewing_party_1.title(@viewing_party_1.movie_id)

      expect(result_1).to eq("Lock, Stock and Two Smoking Barrels")

      result_2 = @viewing_party_2.title(@viewing_party_2.movie_id)

      expect(result_2).to eq("The Godfather")
    end

    it "#host" do
      result_1 = @viewing_party_1.host

      expect(result_1).to eq("John Doe")

      result_2 = @viewing_party_2.host

      expect(result_2).to eq("Alex Smith")
    end

    it "#participants" do
      reuslt_1 = @viewing_party_1.participants(@user_1)

      expect(reuslt_1).to eq("Alex Smith and Elvis Presley")

      result_2 = @viewing_party_2.participants(@user_2)

      expect(result_2).to eq("John Doe, Elvis Presley, and Bob Dylan")
    end
  end

end
