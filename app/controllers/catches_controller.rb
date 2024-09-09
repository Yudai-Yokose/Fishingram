class CatchesController < ApplicationController
  before_action :set_catch, only: %i[show edit update destroy purge_image]
  before_action :authenticate_user!, except: %i[index show new]
  before_action :correct_user, only: %i[edit update destroy purge_image]


  def index
    @catches = Catch.includes(:user, images_attachments: :blob).order(created_at: :desc)
  end

  def user_index
    @catches = current_user.catches.includes(:user, images_attachments: :blob).order(created_at: :desc)
  end

  def show
  end

  def new
    @catch = current_user ? current_user.catches.build : Catch.new
    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("new_catch_form", partial: "catches/form", locals: { catch: @catch })
      }
    end
  end

  def create
    @catch = current_user.catches.build(catch_params)
    if @catch.save
      respond_to do |format|
        format.html { redirect_to catches_path, notice: I18n.t("activerecord.attributes.catch.create.success") }
        format.turbo_stream {
          flash.now[:notice] = I18n.t("activerecord.attributes.catch.create.success")
          render turbo_stream: [
            turbo_stream.prepend("catches", partial: "catches/catch", locals: { catch: @catch }),
            turbo_stream.prepend("user_catches", partial: "catches/user_catch", locals: { catch: @catch }),
            turbo_stream.replace("new_catch_form", partial: "catches/form", locals: { catch: Catch.new }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
      end
    else
      respond_to do |format|
        format.html { render :new, I18n.t("activerecord.attributes.catch.create.failure") }
        format.turbo_stream {
          flash.now[:alert] = I18n.t("activerecord.attributes.catch.create.failure")
          render turbo_stream: [
            turbo_stream.replace("new_catch_form_frame", partial: "catches/form", locals: { catch: @catch }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("edit_catch_form", partial: "catches/form", locals: { catch: @catch })
      }
    end
  end

  def update
    if @catch.update(catch_params.except(:images))
      attach_images if params[:catch][:images]
      respond_to do |format|
        format.html { redirect_to @catch, notice: I18n.t("activerecord.attributes.catch.update.success") }
        format.turbo_stream {
          flash.now[:notice] = I18n.t("activerecord.attributes.catch.update.success")
          render turbo_stream: [
            turbo_stream.replace("catch_#{@catch.id}_details", partial: "catches/details", locals: { catch: @catch }),
            turbo_stream.replace("catch_#{@catch.id}_images", partial: "catches/images", locals: { catch: @catch }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
      end
    else
      respond_to do |format|
        format.html { render :edit, notice: I18n.t("activerecord.attributes.catch.update.failure") }
        format.turbo_stream {
          flash.now[:alert] = I18n.t("activerecord.attributes.catch.update.failure")
          render turbo_stream: [
            turbo_stream.replace("edit_catch_form", partial: "catches/form", locals: { catch: @catch }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
      end
    end
  end

  def destroy
    @catch.destroy
    respond_to do |format|
      format.html { redirect_to catches_path, notice: I18n.t("activerecord.attributes.catch.destroy.success") }
      format.turbo_stream {
        flash.now[:notice] = I18n.t("activerecord.attributes.catch.destroy.success")
        render turbo_stream: [
          turbo_stream.remove("destroy_catch_#{@catch.id}"),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      }
    end
  end

  def purge_image
    image = @catch.images.find(params[:image_id])
    image_id = image.id
    image.purge
    respond_to do |format|
      format.html { redirect_to edit_catch_path(@catch), notice: I18n.t("activerecord.attributes.catch.purge_image.success") }
      format.turbo_stream {
        flash.now[:notice] = I18n.t("activerecord.attributes.catch.purge_image.success")
        render turbo_stream: [
          turbo_stream.remove("slide_#{image_id}"),
          turbo_stream.remove("carousel_link_#{image_id}"),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      }
    end
  end

  private

  def catch_params
    params.require(:catch).permit(:tide, :tide_level, :range, :size, :memo, :latitude, :longitude, images: [])
  end

  def set_catch
    @catch = Catch.includes(:user, images_attachments: :blob).find(params[:id])
  end

  def attach_images
    params[:catch][:images].each do |image|
      @catch.images.attach(image)
    end
  end

  def correct_user
    unless @catch.user == current_user
      redirect_to catches_path, notice: I18n.t("activerecord.attributes.catch.correct_user")
    end
  end
end
