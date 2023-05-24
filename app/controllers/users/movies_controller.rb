class Users::MoviesController < ApplicationController
  before_action :require_account

  def index
    @user = User.find(params[:user_id])
    @facade = MoviesFacade.new(params)
  end

  def show
    @user = User.find(params[:user_id])
    @facade = MoviesFacade.new(params)
  end

  private
  def require_account
    unless current_user
      flash[:error] = "You must be logged in to access the movies page"
      redirect_to root_path
    end
  end
end