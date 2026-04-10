require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { build_user }

  describe "GET /posts" do
    it "redirects guest to login" do
      get posts_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "PATCH /posts/:id" do
    let(:owner_post) do
      post = user.posts.new(caption: "old")
      post.image.attach(uploaded_test_image)
      post.save!
      post
    end

    it "allows owner to update own post" do
      sign_in_user(user)
      patch post_path(owner_post), params: { post: { caption: "new caption" } }
      expect(response).to redirect_to(post_path(owner_post))
      expect(owner_post.reload.caption).to eq("new caption")
    end

    it "does not allow another user to update post" do
      sign_in_user(build_user)
      patch post_path(owner_post), params: { post: { caption: "hacked" } }
      expect(response).to redirect_to(post_path(owner_post))
      expect(owner_post.reload.caption).to eq("old")
    end
  end
end
