class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_post_owner!, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user, :likes).order(created_at: :desc)
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :asc)
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to @post, notice: "Пост опубликован."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Пост обновлен."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: "Пост удален."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:caption, :image)
  end

  def authorize_post_owner!
    return if @post.user == current_user

    redirect_to @post, alert: "Редактировать можно только свои посты."
  end
end
