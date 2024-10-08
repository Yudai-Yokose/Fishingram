class Admin::CatchesController < ApplicationController
  before_action :set_catch, only: %i[show destroy]

  def index
    @catches = Catch.includes(:user, images_attachments: :blob).order(created_at: :desc).page(params[:page]).per(5)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("admin_catch_index_pagination", partial: "admin/catches/admin_index")
      end
      format.html
    end
  end

  def show
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("admin_catch_index_#{@catch.id}_show", partial: "admin/catches/admin_show", locals: { catch: @catch })
      }
      format.html
    end
  end

  def destroy
    @catch.destroy
    respond_to do |format|
      format.turbo_stream {
        flash.now[:notice] = I18n.t("admin.catch.destroy.success")
        render turbo_stream: [
          turbo_stream.remove("admin_catch_#{@catch.id}"),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      }
      format.html { redirect_to admin_catches_path, notice: I18n.t("admin.catch.destroy.success") }
    end
  end

  private

  def set_catch
    @catch = Catch.includes(:user, images_attachments: :blob).find(params[:id])
  end
end
