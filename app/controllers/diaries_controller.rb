class DiariesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!, except: %i[new create]
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
    if user_signed_in?
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
    else
      respond_to do |format|
        format.turbo_stream {
          flash.now[:alert] = I18n.t("devise.failure.unauthenticated")
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.replace("new_diary_form", partial: "diaries/new", locals: { diary: Diary.new })
          ]
        }
        format.html { redirect_to new_user_session_path, alert: I18n.t("devise.failure.unauthenticated") }
      end
    end
  end

  def index
    search_params = params.fetch(:q, {}).permit(:content_cont, :weather_eq, :catch_count_eq, :time_of_day_eq, :temperature_eq)
    @search = current_user.diaries.ransack(search_params)
    @diaries = @search.result(distinct: true).includes(images_attachments: :blob).order(diary_date: :desc).page(params[:page]).per(8)
  end

  def show
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(dom_id(@diary, :show), partial: "diaries/show", locals: { diary: @diary })
      end
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(dom_id(@diary, :edit), partial: "diaries/edit", locals: { diary: @diary })
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
            turbo_stream.update(dom_id(@diary, :details), partial: "diaries/show_details", locals: { diary: @diary }),
            turbo_stream.update(dom_id(@diary, :images), partial: "diaries/show_images", locals: { diary: @diary }),
            turbo_stream.update(dom_id(@diary, :index_image), partial: "diaries/index_image", locals: { diary: @diary }),
            turbo_stream.update(dom_id(@diary, :memo), partial: "diaries/index_memo", locals: { diary: @diary }),
            turbo_stream.update(dom_id(@diary, :edit), partial: "diaries/edit", locals: { diary: @diary }),
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
            turbo_stream.replace(dom_id(@diary, :edit), partial: "dairy/edit", locals: { diary: @diary }),
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
          turbo_stream.remove(dom_id(@diary)),
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
          turbo_stream.remove(dom_id(@diary, :slide)),
          turbo_stream.remove(dom_id(@diary, :carousel_link)),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      }
      format.html { redirect_to edit_diary_path(@diary), notice: I18n.t("activerecord.attributes.diary.purge_image.success") }
    end
  end

  def autocomplete
    query = params[:q]
    suggestions = Diary.where("content LIKE ?", "%#{query}%").limit(10).pluck(:content)
    render json: suggestions
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
