class FeedsController < ApplicationController
  before_action :authenticate_user!

  def show
    followed_ids = current_user.following.select(:id)
    @posts = Post.includes(:user, :likes, image_attachment: :blob)
                 .where(user_id: followed_ids)
                 .or(Post.where(user_id: current_user.id))
                 .order(created_at: :desc)
  end
end
