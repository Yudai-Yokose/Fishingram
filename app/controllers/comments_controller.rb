class CommentsController < ApplicationController
  before_action :set_catch
  before_action :authenticate_user!, except: %i[new]

  def new
    @comment = Comment.new
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("comment_form", partial: "comments/form", locals: { catch: @catch, comment: @comment }) }
      format.html
    end
  end

  def create
    @comment = @catch.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("comments", partial: "comments/comment", locals: { comment: @comment }),
            turbo_stream.replace("comment_form", partial: "comments/form", locals: { catch: @catch, comment: Comment.new })
          ]
        end
        format.html { redirect_to @catch }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { render "catches/show" }
      end
    end
  end

  def destroy
    @comment = @catch.comments.find(params[:id])

    if @comment.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove("comment_#{@comment.id}")
        end
        format.html { redirect_to @catch }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @catch, alert: "Failed to delete comment." }
      end
    end
  end

  private

  def set_catch
    @catch = Catch.find(params[:catch_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
