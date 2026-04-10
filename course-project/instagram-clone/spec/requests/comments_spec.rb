require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:author) { build_user }
  let(:other_user) { build_user }
  let(:post_record) do
    p = author.posts.new(caption: "post")
    p.image.attach(uploaded_test_image)
    p.save!
    p
  end

  it "creates comment for signed in user" do
    sign_in_user(other_user)
    expect {
      post post_comments_path(post_record), params: { comment: { body: "nice post" } }
    }.to change(Comment, :count).by(1)
  end

  it "allows deleting own comment" do
    sign_in_user(other_user)
    comment = post_record.comments.create!(user: other_user, body: "mine")
    expect {
      delete post_comment_path(post_record, comment)
    }.to change(Comment, :count).by(-1)
  end

  it "prevents deleting someone else's comment" do
    sign_in_user(other_user)
    comment = post_record.comments.create!(user: author, body: "author")
    delete post_comment_path(post_record, comment)
    expect(response).to have_http_status(:not_found)
  end

  it "requires authentication" do
    post post_comments_path(post_record), params: { comment: { body: "guest" } }
    expect(response).to redirect_to(new_user_session_path)
  end
end
