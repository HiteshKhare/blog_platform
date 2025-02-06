module Admin
  class DashboardController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin

    def index
      # Fetch all users and their posts
      @users = User.includes(:posts).all
    end

    private

    def check_admin
      redirect_to root_path, alert: 'Access Denied' unless current_user.admin?
    end
  end
end
