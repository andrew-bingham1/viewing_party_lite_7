class UsersController < ApplicationController

  def new 
  end

  def create
    user = User.new(user_params)
    if params[:password] != params[:password_confirmation]
      flash[:error] = "Passwords do not match"
      redirect_to register_path
    else
      if user.save 
        session[:user_id] = user.id
        redirect_to user_path(user)
      else
        flash[:error] = user.errors.full_messages.to_sentence
        redirect_to register_path
      end
    end
  end

  def show
    if current_user.nil?
      flash[:error] = "You must be logged in or registered to access your dashboard"
      redirect_to root_path
    else
      @user = User.find(params[:id])
      @hosted_parties = ViewingParty.find_hosted_parties(@user)
      @invited_parties = ViewingParty.find_invited_parties(@user)
    end
  end

  def login_form
  end

  def login_user
    user = User.find_by(email: params[:email])
    if user.nil?
      record_not_found
    else
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to user_path(user)
      else
        flash[:error] = "Sorry, that password is incorrect"
        render :login_form
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def record_not_found
    flash[:error] = "Sorry, that email is invalid."
    redirect_to login_path
  end

end
