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

  it "sets like and then switches to dislike" do
    sign_in_user(user)

    post post_like_path(post_record)
    reaction = post_record.likes.find_by(user: user)
    expect(reaction).to be_present
    expect(reaction.reaction).to eq("like")

    post post_dislike_path(post_record)
    expect(post_record.likes.find_by(user: user).reaction).to eq("dislike")
  end

  it "shows like and dislike counts on post page" do
    sign_in_user(user)
    post post_like_path(post_record)
    another_user = build_user
    post_record.likes.create!(user: another_user, reaction: :dislike)

    get post_path(post_record)
    expect(response.body).to include("Лайки: 1")
    expect(response.body).to include("Дизлайки: 1")
  end

  it "requires authentication" do
    post post_like_path(post_record)
    expect(response).to redirect_to(new_user_session_path)
  end

  it "requires authentication for dislike" do
    post post_dislike_path(post_record)
    expect(response).to redirect_to(new_user_session_path)
  end
end
