class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    like = @post.likes.find_by(user: current_user)
    if like
      like.destroy
      redirect_to @post, notice: "Лайк снят."
    else
      @post.likes.create!(user: current_user)
      redirect_to @post, notice: "Лайк поставлен."
    end
  end

  def destroy
    like = @post.likes.find_by(user: current_user)
    like&.destroy
    redirect_to @post, notice: "Лайк снят."
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end
end
