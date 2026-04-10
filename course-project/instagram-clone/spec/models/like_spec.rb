require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { build_user }
  let(:post_record) do
    post = user.posts.new(caption: "caption")
    post.image.attach(Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test-image.svg"), "image/svg+xml"))
    post.save!
    post
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:post) }

  it "does not allow duplicate likes for one user and post" do
    described_class.create!(user: user, post: post_record)
    duplicate = described_class.new(user: user, post: post_record)
    expect(duplicate).not_to be_valid
  end
end
