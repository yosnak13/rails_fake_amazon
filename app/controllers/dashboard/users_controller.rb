class Dashboard::UsersController < ApplicationController
  before_action :authenticate_admin!
  layout "dashboard/dashboard"

  def index
    @users = User.display_list(params[:pages])
  end

  def destroy
  end
end
