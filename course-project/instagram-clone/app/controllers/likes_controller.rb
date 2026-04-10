class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def like
    set_reaction(:like)
    redirect_to @post, notice: "Реакция обновлена."
  end

  def dislike
    set_reaction(:dislike)
    redirect_to @post, notice: "Реакция обновлена."
  end

  private

  def set_reaction(reaction)
    existing = @post.likes.find_by(user: current_user)
    if existing&.reaction&.to_sym == reaction
      existing.destroy!
      return
    end

    if existing
      existing.update!(reaction: reaction)
    else
      @post.likes.create!(user: current_user, reaction: reaction)
    end
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
