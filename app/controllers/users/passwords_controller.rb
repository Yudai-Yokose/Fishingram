# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  def new
    self.resource = resource_class.new
    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("password_form", partial: "devise/passwords/form", locals: { resource: resource })
      }
    end
  end

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      flash[:notice] = t("devise.passwords.send_instructions")
      respond_to do |format|
        format.html { redirect_to root_path }
      end
    else
      respond_with(resource)
    end
  end
end
