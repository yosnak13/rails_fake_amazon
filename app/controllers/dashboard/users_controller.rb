class Dashboard::UsersController < ApplicationController
  before_action :authenticate_admin!
  layout "dashboard/dashboard"

  def index
    @users = User.display_list(params[:pages])
  end

  def destroy
    user = User.find(params[:id])
    user.deleted_flg = User.switch_flg(user.deleted_flg)
    user.update
    redirect_to dashboard_users_path
  end
end
