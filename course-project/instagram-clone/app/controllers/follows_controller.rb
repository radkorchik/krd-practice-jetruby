class FollowsController < ApplicationController
  before_action :authenticate_user!

  def create
    target_user = User.find(params[:followed_id])
    follow = current_user.active_follows.new(followed: target_user)

    if follow.save
      redirect_back fallback_location: users_path, notice: "Подписка оформлена."
    else
      redirect_back fallback_location: users_path, alert: follow.errors.full_messages.to_sentence
    end
  end

  def destroy
    follow = current_user.active_follows.find(params[:id])
    follow.destroy
    redirect_back fallback_location: users_path, notice: "Подписка отменена."
  end
end
