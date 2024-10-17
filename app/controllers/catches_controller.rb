class CatchesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!, except: %i[index show new create]
  before_action :set_catch, only: %i[show edit update destroy purge_image]
  before_action :correct_user, only: %i[edit update destroy purge_image]

  def new
    @catch = current_user ? current_user.catches.build : Catch.new
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("new_catch_form", partial: "catches/new", locals: { catch: @catch })
      }
      format.html
    end
  end

  def create
    if user_signed_in?
      @catch = current_user.catches.build(catch_params)
      if @catch.save
        respond_to do |format|
          format.turbo_stream {
            flash.now[:notice] = I18n.t("activerecord.attributes.catch.create.success")
            render turbo_stream: [
              turbo_stream.prepend("catch_index", partial: "catches/index_content", locals: { catch: @catch }),
              turbo_stream.prepend("catch_index_user", partial: "catches/index_content", locals: { catch: @catch }),
              turbo_stream.replace("new_catch_form", partial: "catches/new", locals: { catch: Catch.new }),
              turbo_stream.update("flash", partial: "shared/flash")
            ]
          }
          format.html { redirect_to catches_path, notice: I18n.t("activerecord.attributes.catch.create.success") }
        end
      else
        respond_to do |format|
          format.turbo_stream {
            flash.now[:alert] = I18n.t("activerecord.attributes.catch.create.failure")
            render turbo_stream: [
              turbo_stream.replace("new_catch_form", partial: "catches/new", locals: { catch: @catch }),
              turbo_stream.update("flash", partial: "shared/flash")
            ]
          }
          format.html { render :new, alert: I18n.t("activerecord.attributes.catch.create.failure") }
        end
      end
    else
      respond_to do |format|
        format.turbo_stream {
          flash.now[:alert] = I18n.t("devise.failure.unauthenticated")
          render turbo_stream: [
            turbo_stream.update("flash", partial: "shared/flash"),
            turbo_stream.replace("new_catch_form", partial: "catches/new", locals: { catch: Catch.new })
          ]
        }
        format.html { redirect_to new_user_session_path, alert: I18n.t("devise.failure.unauthenticated") }
      end
    end
  end

  def index
    @catches = Catch.includes(:user, :comments, images_attachments: :blob).order(created_at: :desc).page(params[:page]).per(8)
  end

  def index_user
    @catches = current_user.catches.includes(:user, :comments, images_attachments: :blob).order(created_at: :desc).page(params[:page]).per(8)
  end

  def show
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(dom_id(@catch, :show), partial: "catches/show", locals: { catch: @catch })
      }
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(dom_id(@catch, :edit), partial: "catches/edit", locals: { catch: @catch })
      }
      format.html
    end
  end

  def update
    if @catch.update(catch_params.except(:images))
      attach_images if params[:catch][:images]
      respond_to do |format|
        format.turbo_stream {
          flash.now[:notice] = I18n.t("activerecord.attributes.catch.update.success")
          render turbo_stream: [
            turbo_stream.update(dom_id(@catch, :details), partial: "catches/show_details", locals: { catch: @catch }),
            turbo_stream.update(dom_id(@catch, :images), partial: "catches/show_images", locals: { catch: @catch }),
            turbo_stream.update(dom_id(@catch, :index_image), partial: "catches/index_image", locals: { catch: @catch }),
            turbo_stream.update(dom_id(@catch, :memo), partial: "catches/index_memo", locals: { catch: @catch }),
            turbo_stream.update(dom_id(@catch, :edit), partial: "catches/edit", locals: { catch: @catch }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
        format.html { redirect_to @catch, notice: I18n.t("activerecord.attributes.catch.update.success") }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          flash.now[:alert] = I18n.t("activerecord.attributes.catch.update.failure")
          render turbo_stream: [
            turbo_stream.replace(dom_id(@catch, :edit), partial: "catches/edit", locals: { catch: @catch }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        }
        format.html { render :edit, notice: I18n.t("activerecord.attributes.catch.update.failure") }
      end
    end
  end

  def destroy
    @catch.destroy
    respond_to do |format|
      format.turbo_stream {
        flash.now[:notice] = I18n.t("activerecord.attributes.catch.destroy.success")
        render turbo_stream: [
          turbo_stream.remove(dom_id(@catch)),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      }
      format.html { redirect_to catches_path, notice: I18n.t("activerecord.attributes.catch.destroy.success") }
    end
  end

  def purge_image
    image = @catch.images.find(params[:image_id])
    image_id = image.id
    image.purge
    respond_to do |format|
      format.turbo_stream {
        flash.now[:notice] = I18n.t("activerecord.attributes.catch.purge_image.success")
        render turbo_stream: [
          turbo_stream.remove(dom_id(@catch, :slide)),
          turbo_stream.remove(dom_id(@catch, :carousel_link)),
          turbo_stream.update("flash", partial: "shared/flash")
        ]
      }
      format.html { redirect_to edit_catch_path(@catch), notice: I18n.t("activerecord.attributes.catch.purge_image.success") }
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
