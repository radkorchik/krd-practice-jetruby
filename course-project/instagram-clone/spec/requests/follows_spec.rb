require 'rails_helper'

RSpec.describe "Follows", type: :request do
  let(:user) { build_user }
  let(:other_user) { build_user }

  it "follows and unfollows user" do
    sign_in_user(user)

    post follows_path, params: { followed_id: other_user.id }
    expect(user.following.reload).to include(other_user)

    follow = user.active_follows.find_by!(followed: other_user)
    delete follow_path(follow)
    expect(user.following.reload).not_to include(other_user)
  end

  it "does not allow following yourself" do
    sign_in_user(user)
    post follows_path, params: { followed_id: user.id }
    expect(user.following.reload).to be_empty
  end

  it "requires authentication" do
    post follows_path, params: { followed_id: other_user.id }
    expect(response).to redirect_to(new_user_session_path)
  end
end
