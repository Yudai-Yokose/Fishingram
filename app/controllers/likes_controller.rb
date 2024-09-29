class LikesController < ApplicationController
  before_action :set_catch

  def create
    if user_signed_in?
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
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = I18n.t("devise.failure.unauthenticated")
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
        format.html { redirect_to new_user_session_path, alert: I18n.t("devise.failure.unauthenticated") }
      end
    end
  end

  def destroy
    if user_signed_in?
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
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = I18n.t("devise.failure.unauthenticated")
          render turbo_stream: turbo_stream.update("flash", partial: "shared/flash")
        end
        format.html { redirect_to new_user_session_path, alert: I18n.t("devise.failure.unauthenticated") }
      end
    end
  end

  private

  def set_catch
    @catch = Catch.find(params[:catch_id])
  end
end
