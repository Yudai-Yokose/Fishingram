class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [ :destroy ]

  def index
    @users = User.all.order(created_at: :desc).page(params[:page])
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "ユーザーを削除しました"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :admin)
  end
end
