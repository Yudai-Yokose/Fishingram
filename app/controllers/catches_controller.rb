class CatchesController < ApplicationController
  before_action :set_catch, only: %i[show edit update destroy purge_image]
  before_action :authenticate_user!, except: %i[index show new]
  before_action :correct_user, only: %i[edit update destroy purge_image]


  def index
    @catches = Catch.includes(:user, images_attachments: :blob).order(created_at: :desc)
    session[:source] = "all"
  end

  def user_index
    @catches = current_user.catches.includes(:user, images_attachments: :blob).order(created_at: :desc)
    session[:source] = "user"
  end

  def show
  end

  def new
    @catch = current_user ? current_user.catches.build : Catch.new
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
            turbo_stream.replace("new_catch_form_frame", partial: "catches/form", locals: { catch: Catch.new }),
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
  end

  def update
    if @catch.update(catch_params.except(:images))
      attach_images if params[:catch][:images]
      redirect_to @catch, notice: I18n.t("activerecord.attributes.catch.update.success")
    else
      render :edit, notice: I18n.t("activerecord.attributes.catch.update.failure")
    end
  end

  def destroy
    @catch.destroy
    redirect_to catches_path, notice: I18n.t("activerecord.attributes.catch.destroy.success")
  end

  def purge_image
    image = @catch.images.find(params[:image_id])
    image.purge
    redirect_to edit_catch_path(@catch), notice: I18n.t("activerecord.attributes.catch.purge_image.success")
  end

  private

  def catch_params
    params.require(:catch).permit(:tide, :tide_level, :range, :size, :memo, :latitude, :longitude, images: [])
  end

  def set_catch
    @catch = Catch.includes(:user, images_attachments: :blob).find(params[:id])
    Rails.logger.debug "Catch set to: #{@catch.inspect}"
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
