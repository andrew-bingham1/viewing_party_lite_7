class UsersController < ApplicationController

  def new 
  end

  def create
    @user = User.new(user_params)
    if params[:password] == params[:password_confirmation] && @user.save
      flash[:success] = "Welcome, #{@user.name}!"
      redirect_to user_path(@user)
    elsif  params[:password] != params[:password_confirmation]
      flash[:error] = "Passwords do not match"
      redirect_to register_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to register_path
    end
  end

  def create
    @user = User.new(user_params)
    if params[:password] != params[:password_confirmation]
      flash[:error] = "Passwords do not match"
        redirect_to register_path
    else
      if @user.save 
        redirect_to user_path(@user)
      else
        flash[:error] = @user.errors.full_messages.to_sentence
        redirect_to register_path
      end
    end
  end

   def show
    @user = User.find(params[:id])
    @hosted_parties = ViewingParty.find_hosted_parties(@user)
    @invited_parties = ViewingParty.find_invited_parties(@user)
    
  end

  def login_form
  end

  def login_user
    user = User.find_by(email: params[:email])
    if user.nil?
      flash[:error] = "Sorry, your credentials are bad."
      redirect_to login_path
      return
    end
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Welcome, #{user.name}!"
      if user.admin?
        redirect_to admin_dashboard_path
      elsif user.manager?
        redirect_to user_path(user)
      elsif
        redirect_to user_path(user)
      end
    else
      flash[:error] = "Sorry, your credentials are bad."
      redirect_to login_path
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

end
