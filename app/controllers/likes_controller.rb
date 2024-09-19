class LikesController < ApplicationController
  before_action :set_catch
  before_action :authenticate_user!

  def create
    @like = @catch.likes.new(user: current_user)

    if @like.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("like_button_#{@catch.id}", partial: "likes/like_button", locals: { catch: @catch })
        end
        format.html
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html
      end
    end
  end

  def destroy
    @like = @catch.likes.find_by(user: current_user)

    if @like.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("like_button_#{@catch.id}", partial: "likes/like_button", locals: { catch: @catch })
        end
        format.html
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html
      end
    end
  end

  private

  def set_catch
    @catch = Catch.find(params[:catch_id])
  end
end
