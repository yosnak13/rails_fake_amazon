class UsersController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    # update_without_passwordはgem deviseで使えるメソッドで定義不要。パスワードなしでユーザー情報を更新するメソッド。
    @user.update_without_password(user_params)
    redirect_to mypage_users_url
  end

  def mypage
  end

  def edit_address
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.permit(:name, :email, :phone, :password_confirmation)
end
