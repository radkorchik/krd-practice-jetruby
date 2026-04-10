require 'rails_helper'

RSpec.describe Post, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:likes).dependent(:destroy) }

  it "is invalid without an image" do
    post = Post.new(user: build_user, caption: "caption")
    expect(post).not_to be_valid
  end
end
