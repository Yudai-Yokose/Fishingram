# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    posts_path # Redirect to the posts index page after sign-up
  end

  # Override the after_inactive_sign_up_path_for method for cases where sign up needs email confirmation
  def after_inactive_sign_up_path_for(resource)
    posts_path # Redirect to the posts index page after sign-up but before email confirmation
  end
end
