class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: :create

  def create
    comment = @post.comments.new(comment_params)
    comment.user = current_user

    if comment.save
      redirect_to @post, notice: "Комментарий добавлен."
    else
      redirect_to @post, alert: comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.user == current_user || comment.post.user == current_user
      comment.destroy
      redirect_to comment.post, notice: "Комментарий удален."
    else
      redirect_to comment.post, alert: "Удалять этот комментарий нельзя."
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
