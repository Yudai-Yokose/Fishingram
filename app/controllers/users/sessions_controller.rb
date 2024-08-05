# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  def create
    if params[:user][:email].blank? || params[:user][:password].blank?
      flash[:alert] = "Emailとパスワードを入力してください。"
      redirect_to new_user_session_path and return
    end
    super
  end
end
