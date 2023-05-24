class Users::MoviesController < ApplicationController
  before_action :find_user  
  def index
    @facade = MoviesFacade.new(params)
  end

  def show
    @facade = MoviesFacade.new(params)
  end

  private 

  def find_user
    @user = current_user
  end

end