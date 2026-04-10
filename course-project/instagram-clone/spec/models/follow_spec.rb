require 'rails_helper'

RSpec.describe Follow, type: :model do
  let(:follower) { build_user }
  let(:followed) { build_user }
  subject(:follow) { described_class.new(follower: follower, followed: followed) }

  it { is_expected.to belong_to(:follower).class_name("User") }
  it { is_expected.to belong_to(:followed).class_name("User") }

  it "does not allow self-following" do
    follow = described_class.new(follower: follower, followed: follower)
    expect(follow).not_to be_valid
  end

  it "does not allow duplicate follow pair" do
    described_class.create!(follower: follower, followed: followed)
    duplicate = described_class.new(follower: follower, followed: followed)
    expect(duplicate).not_to be_valid
  end
end
