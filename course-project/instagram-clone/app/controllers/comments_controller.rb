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
    comment = current_user.comments.find(params[:id])
    post = comment.post
    comment.destroy
    redirect_to post, notice: "Комментарий удален."
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
