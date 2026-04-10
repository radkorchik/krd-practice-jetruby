require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let(:user) { build_user }
  let(:author) { build_user }
  let(:post_record) do
    p = author.posts.new(caption: "post")
    p.image.attach(uploaded_test_image)
    p.save!
    p
  end

  it "toggles like and dislike" do
    sign_in_user(user)

    post post_like_path(post_record)
    expect(post_record.likes.where(user: user).exists?).to be(true)

    post post_like_path(post_record)
    expect(post_record.likes.where(user: user).exists?).to be(false)
  end

  it "shows like count on post page" do
    sign_in_user(user)
    post post_like_path(post_record)

    get post_path(post_record)
    expect(response.body).to include("Лайки: 1")
  end

  it "requires authentication" do
    post post_like_path(post_record)
    expect(response).to redirect_to(new_user_session_path)
  end
end
