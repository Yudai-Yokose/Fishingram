# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    Rails.logger.debug "Google OAuth2 callback triggered"
    puts "Google OAuth2 callback triggered"

    auth = request.env["omniauth.auth"]
    Rails.logger.debug "OmniAuth auth data: #{auth.inspect}"

    @user = User.from_omniauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = auth.except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path
  end
end
