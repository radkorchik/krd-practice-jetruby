require 'rails_helper'

RSpec.describe "Feeds", type: :request do
  let(:user) { build_user }
  let(:followed_user) { build_user }
  let(:outsider) { build_user }

  it "shows followed and own posts in feed" do
    followed_post = followed_user.posts.new(caption: "followed post")
    followed_post.image.attach(uploaded_test_image)
    followed_post.save!
    own_post = user.posts.new(caption: "own post")
    own_post.image.attach(uploaded_test_image)
    own_post.save!
    outsider_post = outsider.posts.new(caption: "outsider post")
    outsider_post.image.attach(uploaded_test_image)
    outsider_post.save!
    user.active_follows.create!(followed: followed_user)

    sign_in_user(user)
    get feed_path

    expect(response.body).to include("followed post")
    expect(response.body).to include("own post")
    expect(response.body).not_to include("outsider post")
  end

  it "requires authentication" do
    get feed_path
    expect(response).to redirect_to(new_user_session_path)
  end
end
