class CatchesController < ApplicationController
  before_action :set_catch, only: %i[show edit update destroy purge_image]
  before_action :authenticate_user!, except: %i[index show new]
  before_action :correct_user, only: %i[edit update destroy purge_image]


  def index
    @catches = Catch.includes(:user, images_attachments: :blob).order(created_at: :desc)
  end

  def user_catches
    @catches = current_user.catches.includes(:user, images_attachments: :blob).order(created_at: :desc)
  end

  def show
  end

  def new
    @catch = current_user ? current_user.catches.build : Catch.new
  end

  def create
    @catch = current_user.catches.build(catch_params)
    if @catch.save
      redirect_to catches_path, notice: I18n.t('activerecord.attributes.catch.create.success')
    else
      render :new, notice: I18n.t('activerecord.attributes.catch.create.failure')
    end
  end

  def edit
  end

  def update
    if @catch.update(catch_params.except(:images))
      attach_images if params[:catch][:images]
      redirect_to @catch, notice: I18n.t('activerecord.attributes.catch.update.success')
    else
      render :edit, notice: I18n.t('activerecord.attributes.catch.update.failure')
    end
  end

  def destroy
    @catch.destroy
    redirect_to catches_path, notice: I18n.t('activerecord.attributes.catch.destroy.success')
  end

  def purge_image
    image = @catch.images.find(params[:image_id])
    image.purge
    redirect_to edit_catch_path(@catch), notice: I18n.t('activerecord.attributes.catch.purge_image.success')
  end

  private

  def catch_params
    params.require(:catch).permit(:tide, :tide_level, :range, :size, :memo, :latitude, :longitude, images: []).tap do |p|
      p[:tide] = p[:tide].to_i if p[:tide].present?
      p[:tide_level] = p[:tide_level].to_i if p[:tide_level].present?
      p[:range] = p[:range].to_i if p[:range].present?
      p[:size] = p[:size].to_i if p[:size].present?
    end
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
      redirect_to catches_path, notice: I18n.t('activerecord.attributes.catch.correct_user')
    end
  end
end
