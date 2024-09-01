class DiariesController < ApplicationController
  before_action :set_diary, only: %i[show edit update destroy purge_image]
  before_action :authenticate_user!, except: %i[new]
  before_action :correct_user, only: %i[show edit update destroy purge_image]

  def index
    @diaries = current_user.diaries.includes(images_attachments: :blob).order(created_at: :desc)
  end

  def show
  end

  def new
    @diary = current_user ? current_user.diaries.build : Diary.new
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      respond_to do |format|
        format.html { redirect_to diaries_path, notice: I18n.t("activerecord.attributes.diary.create.success") }
        format.turbo_stream {
          flash.now[:notice] = I18n.t("activerecord.attributes.diary.create.success")
          render turbo_stream: [
            turbo_stream.prepend("diaries", partial: "diaries/diary", locals: { diary: @diary }),
            turbo_stream.replace("new_diary_form_frame", partial: "diaries/form", locals: { diary: Diary.new }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
      end
    else
      respond_to do |format|
        format.html { render :new, notice: I18n.t("activerecord.attributes.diary.create.failure") }
        format.turbo_stream {
          flash.now[:alert] = I18n.t("activerecord.attributes.diary.create.failure")
          render turbo_stream: [
            turbo_stream.replace("new_diary_form_frame", partial: "diaries/form", locals: { diary: @diary }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
      end
    end
  end

  def edit
  end

  def update
    if @diary.update(diary_params.except(:images))
      attach_images if params[:diary][:images]
      redirect_to @diary, notice: I18n.t("activerecord.attributes.diary.update.success")
    else
      render :edit, notice: I18n.t("activerecord.attributes.diary.update.failure")
    end
  end

  def destroy
    @diary.destroy
    redirect_to diaries_path, notice: I18n.t("activerecord.attributes.diary.destroy.success")
  end

  def purge_image
    image = @diary.images.find(params[:image_id])
    image.purge
    redirect_to edit_diary_path(@diary), notice: I18n.t("activerecord.attributes.diary.purge_image.success")
  end

  private

  def diary_params
    params.require(:diary).permit(:diary_date, :weather, :catch_count, :time_of_day, :temperature, :content, images: [])
  end

  def set_diary
    @diary = Diary.includes(:user, images_attachments: :blob).find(params[:id])
  end

  def attach_images
    params[:diary][:images].each do |image|
      @diary.images.attach(image)
    end
  end

  def correct_user
    unless @diary.user == current_user
      redirect_to diaries_path, notice: I18n.t("activerecord.attributes.diary.correct_user")
    end
  end
end
