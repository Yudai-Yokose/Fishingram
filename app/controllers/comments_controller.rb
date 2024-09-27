class CommentsController < ApplicationController
  before_action :set_catch
  before_action :authenticate_user!
  before_action :set_comment, only: [ :edit, :update, :destroy ]

  def new
    @comment = @catch.comments.build
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("new_comment_#{@catch.id}_form", partial: "comments/new", locals: { catch: @catch, comment: @comment }) }
      format.html
    end
  end

  def create
    @comment = @catch.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = I18n.t("activerecord.attributes.comment.create.success")
          render turbo_stream: [
            turbo_stream.append("catch_#{@catch.id}_comments", partial: "comments/comment", locals: { catch: @catch, comment: @comment }),
            turbo_stream.replace("new_comment_#{@catch.id}_form", partial: "comments/new", locals: { catch: @catch, comment: Comment.new }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
        format.html { redirect_to @catch, notice: I18n.t("activerecord.attributes.comment.create.success") }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = I18n.t("activerecord.attributes.comment.create.failure")
          render turbo_stream: [
            turbo_stream.replace("new_comment_#{@catch.id}_form", partial: "comments/new", locals: { catch: @catch, comment: @comment }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
        format.html { render "catches/show", alert: I18n.t("activerecord.attributes.comment.create.failure") }
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("edit_comment_#{@comment.id}_form", partial: "comments/edit", locals: { catch: @catch, comment: @comment }) }
      format.html
    end
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = I18n.t("activerecord.attributes.comment.update.success")
          render turbo_stream: [
            turbo_stream.update("comment_#{@comment.id}", partial: "comments/comment", locals: { catch: @catch, comment: @comment }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
        format.html { redirect_to @catch, notice: I18n.t("activerecord.attributes.comment.update.success") }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = I18n.t("activerecord.attributes.comment.update.failure")
          render turbo_stream: [
            turbo_stream.replace("edit_comment_#{@comment.id}_form", partial: "comments/edit", locals: { catch: @catch, comment: @comment }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
        format.html { render :edit, alert: I18n.t("activerecord.attributes.comment.update.failure") }
      end
    end
  end

  def destroy
    if @comment.destroy
      respond_to do |format|
        format.turbo_stream do
          flash.now[:notice] = I18n.t("activerecord.attributes.comment.destroy.success")
          render turbo_stream: [
            turbo_stream.remove("comment_#{@comment.id}"),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
        format.html { redirect_to @catch, notice: I18n.t("activerecord.attributes.comment.destroy.success") }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = I18n.t("activerecord.attributes.comment.destroy.failure")
          render turbo_stream.update("flash", partial: "shared/flash")
        end
        format.html { redirect_to @catch, alert: I18n.t("activerecord.attributes.comment.destroy.failure") }
      end
    end
  end

  private

  def set_catch
    @catch = Catch.includes(:user).find(params[:catch_id])
  end

  def set_comment
    @comment = @catch.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
