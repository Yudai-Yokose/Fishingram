class CommentsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_catch
  before_action :authenticate_user!, except: %i[new create index]
  before_action :set_comment, only: [ :edit, :update, :destroy ]

  def new
    @comment = @catch.comments.build
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@catch, :new_comment_form), partial: "comments/new", locals: { catch: @catch, comment: @comment }) }
      format.html
    end
  end

  def create
    if user_signed_in?
        @comment = @catch.comments.build(comment_params)
        @comment.user = current_user
        if @comment.save
          respond_to do |format|
            format.turbo_stream do
              render turbo_stream: [
                turbo_stream.append(dom_id(@catch, :comments), partial: "comments/comment", locals: { catch: @catch, comment: @comment }),
                turbo_stream.remove(dom_id(@catch, :no_comments_message)),
                turbo_stream.replace(dom_id(@catch, :new_comment_form), partial: "comments/new", locals: { catch: @catch, comment: Comment.new })
              ]
            end
            format.html
          end
        else
          respond_to do |format|
            format.turbo_stream do
              flash.now[:alert] = I18n.t("activerecord.attributes.comment.create.failure")
              render turbo_stream: [
                turbo_stream.replace(dom_id(catch, :new_comment_form), partial: "comments/new", locals: { catch: @catch, comment: Comment.new })
              ]
            end
            format.html
          end
        end
    else
        respond_to do |format|
          format.turbo_stream do
            flash.now[:alert] = I18n.t("devise.failure.unauthenticated")
            render turbo_stream: [
              turbo_stream.update("flash", partial: "shared/flash"),
              turbo_stream.replace(dom_id(@catch, :new_comment_form), partial: "comments/new", locals: { catch: @catch, comment: Comment.new })
            ]
          end
          format.html
        end
    end
  end

  def index
    @comments = @catch.comments.includes(:user).order(created_at: :asc)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(dom_id(@catch, :comments), partial: "comments/index", locals: { catch: @catch, comments: @comments })
      end
      format.html { render partial: "comments/index", locals: { catch: @catch, comments: @comments } }
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@comment, :edit), partial: "comments/edit", locals: { catch: @catch, comment: @comment }) }
      format.html
    end
  end

  def update
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update(dom_id(@comment, :content), partial: "comments/comment_content", locals: { catch: @catch, comment: @comment })
          ]
        end
        format.html
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = I18n.t("activerecord.attributes.comment.update.failure")
          render turbo_stream: [
            turbo_stream.replace(dom_id(@comment, :edit), partial: "comments/edit", locals: { catch: @catch, comment: @comment }),
            turbo_stream.update("flash", partial: "shared/flash")
          ]
        end
        format.html
      end
    end
  end

  def destroy
    if @comment.destroy
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove(dom_id(@comment))
          ]
        end
        format.html
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = I18n.t("activerecord.attributes.comment.destroy.failure")
          render turbo_stream.update("flash", partial: "shared/flash")
        end
        format.html
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
