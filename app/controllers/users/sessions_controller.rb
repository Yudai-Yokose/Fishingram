# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  
  def after_sign_in_path_for(resource)
    posts_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def create
    if params[:user][:email].blank? || params[:user][:password].blank?
      flash[:alert] = "Emailとパスワードを入力してください。"
      redirect_to new_user_session_path and return
    end
    super
  end
end
