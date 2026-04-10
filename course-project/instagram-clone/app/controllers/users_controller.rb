class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id).order(:username)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(image_attachment: :blob).order(created_at: :desc)
    @follow = current_user.active_follows.find_by(followed: @user)
  end
end
