class Users::DiscoverController < ApplicationController
  before_action :find_user
  def index
  end

  private
  
  def find_user
    @user = current_user
  end
end