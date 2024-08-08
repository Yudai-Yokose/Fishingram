# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_up_path_for(resource)
    osts_path
  end

  def after_update_path_for(resource)
    posts_path
  end

  def create
    build_resource(sign_up_params)

    resource.save
    if resource.persisted?
      if resource.image.blank?
        if resource[:image].present? && resource[:image].start_with?('http')
          # 外部URLの画像を初期画像として設定
          resource.image.attach(io: URI.open(resource[:image]), filename: 'profile_image.jpg', content_type: 'image/jpeg')
        else
          # デフォルトの画像を設定
          default_image_path = Rails.root.join('app', 'assets', 'images', 'default_profile_image.png')
          resource.image.attach(io: File.open(default_image_path), filename: 'default_profile_image.png', content_type: 'image/png')
        end
      end
      yield resource if block_given?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :image])
  end

  def update_resource(resource, params)
    if params[:password].blank? && params[:password_confirmation].blank?
      resource.update_without_password(params.except(:current_password))
    else
      resource.update_with_password(params)
    end
  end
end
