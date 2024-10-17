class Admin::CatchesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :require_admin
  before_action :set_catch, only: %i[show destroy]

  def index
    @catches = Catch.includes(:user, images_attachments: :blob).order(created_at: :desc).page(params[:page]).per(8)
  end

  def show
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(dom_id(@catch, :admin_show), partial: "admin/catches/admin_show", locals: { catch: @catch })
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
          turbo_stream.remove(dom_id(@catch, :admin)),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      }
      format.html
    end
  end

  private

  def set_catch
    @catch = Catch.includes(:user, images_attachments: :blob).find(params[:id])
  end
end
