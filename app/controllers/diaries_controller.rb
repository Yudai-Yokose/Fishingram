class DiariesController < ApplicationController
  before_action :authenticate_user!, except: %i[new]
  before_action :set_diary, only: %i[show edit update destroy purge_image]
  before_action :correct_user, only: %i[show edit update destroy purge_image]

  def new
    @diary = current_user ? current_user.diaries.build : Diary.new
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("new_diary_form", partial: "diaries/new", locals: { diary: @diary })
      }
      format.html
    end
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      respond_to do |format|
        format.turbo_stream {
          flash.now[:notice] = I18n.t("activerecord.attributes.diary.create.success")
          render turbo_stream: [
            turbo_stream.prepend("diary_index", partial: "diaries/index_content", locals: { diary: @diary }),
            turbo_stream.replace("new_diary_form", partial: "diaries/new", locals: { diary: Diary.new }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
        format.html { redirect_to diaries_path, notice: I18n.t("activerecord.attributes.diary.create.success") }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          flash.now[:alert] = I18n.t("activerecord.attributes.diary.create.failure")
          render turbo_stream: [
            turbo_stream.replace("new_diary_form", partial: "diaries/new", locals: { diary: @diary }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
        format.html { render :new, notice: I18n.t("activerecord.attributes.diary.create.failure") }
      end
    end
  end

  def index
    @diaries = current_user.diaries.includes(images_attachments: :blob).order(diary_date: :desc).page(params[:page]).per(5)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("diary_index_pagination", partial: "diaries/index")
      end
      format.html
    end
  end

  def show
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("diary_index_#{@diary.id}_show", partial: "diaries/show", locals: { diary: @diary })
      end
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("edit_diary_#{@diary.id}_form", partial: "diaries/edit", locals: { diary: @diary })
      }
      format.html
    end
  end

  def update
    if @diary.update(diary_params.except(:images))
      attach_images if params[:diary][:images]
      respond_to do |format|
        format.turbo_stream {
          flash.now[:notice] = I18n.t("activerecord.attributes.diary.update.success")
          render turbo_stream: [
            turbo_stream.update("diary_show_#{@diary.id}_details", partial: "diaries/show_details", locals: { diary: @diary }),
            turbo_stream.update("diary_show_#{@diary.id}_images", partial: "diaries/show_images", locals: { diary: @diary }),
            turbo_stream.update("diary_index_#{@diary.id}_image", partial: "diaries/index_image", locals: { diary: @diary }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
        format.html { redirect_to @diary, notice: I18n.t("activerecord.attributes.diary.update.success") }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          flash.now[:alert] = I18n.t("activerecord.attributes.diary.update.failure")
          render turbo_stream: [
            turbo_stream.replace("edit_diary_#{@diary.id}_form", partial: "dairy/edit", locals: { diary: @diary }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
        format.html { render :edit, notice: I18n.t("activerecord.attributes.diary.update.failure") }
      end
    end
  end

  def destroy
    @diary.destroy
    respond_to do |format|
      format.turbo_stream {
        flash.now[:notice] = I18n.t("activerecord.attributes.diary.destroy.success")
        render turbo_stream: [
          turbo_stream.remove("diary_#{@diary.id}"),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      }
      format.html { redirect_to diaries_path, notice: I18n.t("activerecord.attributes.diary.destroy.success") }
    end
  end

  def purge_image
    image = @diary.images.find(params[:image_id])
    image_id = image.id
    image.purge
    respond_to do |format|
      format.turbo_stream {
        flash.now[:notice] = I18n.t("activerecord.attributes.diary.purge_image.success")
        render turbo_stream: [
          turbo_stream.remove("diary_slide_#{image_id}"),
          turbo_stream.remove("diary_carousel_link_#{image_id}"),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      }
      format.html { redirect_to edit_diary_path(@diary), notice: I18n.t("activerecord.attributes.diary.purge_image.success") }
    end
  end

  private

  def diary_params
    params.require(:diary).permit(:diary_date, :weather, :catch_count, :time_of_day, :temperature, :content, :latitude, :longitude, images: [])
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
