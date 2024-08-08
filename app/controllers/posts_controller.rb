class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy purge_image]
  before_action :authenticate_user!, except: %i[index show]
  before_action :correct_user, only: %i[edit update destroy purge_image]

  def index
    @posts = Post.includes(:user, images_attachments: :blob).all.order(created_at: :desc).page(params[:page]).per(5)
    @post = Post.new
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: '釣果を記録しました。'
    else
      render :new
    end
  end

  def update
    if @post.update(post_params.except(:images))
      attach_images if params[:post][:images]
      redirect_to @post, notice: '釣果を更新しました。'
    else
      render :edit
    end
  end

  def purge_image
    image = @post.images.find(params[:image_id])
    image.purge
    redirect_to edit_post_path(@post), notice: '画像を削除しました。'
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: '釣果を削除しました。'
  end

  def user_posts
    @posts = current_user.posts.includes(:user, images_attachments: :blob).order(created_at: :desc).page(params[:page]).per(5)
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def correct_user
    unless @post.user == current_user
      redirect_to posts_path, notice: '権限がありません。'
    end
  end

  def post_params
    params.require(:post).permit(:tide, :tide_level, :range, :size, :memo, images: [])
  end

  def attach_images
    params[:post][:images].each do |image|
      @post.images.attach(image)
    end
  end
end
