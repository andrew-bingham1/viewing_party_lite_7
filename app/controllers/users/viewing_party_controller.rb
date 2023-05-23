class Users::ViewingPartyController < ApplicationController
  def new
    if current_user.nil?
      flash[:error] = 'You must be logged in to create a viewing party'
      redirect_to user_movie_path(params[:user_id], params[:id])
    else
      @facade = MoviesFacade.new(params)
      @user = User.find(params[:user_id])
      @users = User.all_except_me(@user)
    end
  end

 def create
  @viewing_party = ViewingParty.new(viewing_party_params)
    if params.dig(:viewing_party, :user_ids).present?
      if @viewing_party.save
        params[:viewing_party][:user_ids].each do |user_id|
          ViewingPartyUser.create(user_id: user_id, viewing_party_id: @viewing_party.id)
        end
        redirect_to user_path(params[:user_id])
      else
        flash[:error] = @viewing_party.errors.full_messages.to_sentence
        redirect_to user_new_viewing_party_path(params[:user_id], params[:id])
      end
    else
      flash[:error] = "You must select at least one friend to invite."
      redirect_to user_new_viewing_party_path(params[:user_id], params[:id])
    end
  end

 

 private

  def viewing_party_params
    params.permit(:movie_id, :duration, :date, :start_time, :user_id)
  end

end