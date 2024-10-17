class Admin::DiariesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :require_admin
  before_action :set_diary, only: %i[show destroy]

  def index
    @diaries = Diary.includes(:user).order(created_at: :desc).page(params[:page]).per(8)
  end

  def show
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(dom_id(@diary, :admin_show), partial: "admin/diaries/admin_show", locals: { diary: @diary })
      }
      format.html
    end
  end

  def destroy
    @diary.destroy
    respond_to do |format|
      format.turbo_stream {
        flash.now[:notice] = I18n.t("admin.diary.destroy.success")
        render turbo_stream: [
          turbo_stream.remove("admin_diary_#{@diary.id}"),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      }
      format.html { redirect_to admin_diaries_path, notice: I18n.t("admin.diary.destroy.success") }
    end
  end

  private

  def set_diary
    @diary = Diary.includes(:user).find(params[:id])
  end
end
