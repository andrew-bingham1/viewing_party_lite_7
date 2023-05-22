class UsersController < ApplicationController

  def new 
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to register_path
    end
  end

   def show
    @user = User.find(params[:id])
    @hosted_parties = ViewingParty.find_hosted_parties(@user)
    @invited_parties = ViewingParty.find_invited_parties(@user)
    
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

end
