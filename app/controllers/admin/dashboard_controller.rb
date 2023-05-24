class Admin::DashboardController < ApplicationController
  before_action :require_admin

  def index
  end

  private
    def require_admin
      # render file: "public/404.html" unless current_admin?
      unless current_admin?
        flash[:error] = "You must be logged in to access the admin dashboard"
        redirect_to root_path
      end
    end
end