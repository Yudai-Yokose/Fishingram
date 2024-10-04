# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
    catches_path
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    respond_to do |format|
      if resource.update(account_update_params)
        format.turbo_stream do
          flash.now[:notice] = t("devise.registrations.updated")
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.replace("edit_content", partial: "edit_content", locals: { resource: resource }),
            turbo_stream.replace("edit_form", partial: "edit_form", locals: { resource: resource })
          ]
        end
      else
        clean_up_passwords resource
        flash.now[:alert] = resource.errors.full_messages.join("\n")
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("edit_form", partial: "edit_form", locals: { resource: resource }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
      end
    end
  end
end
