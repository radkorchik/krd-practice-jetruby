class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_one_attached :image

  validates :image, presence: true

  def likes_count
    likes.reaction_like.count
  end

  def dislikes_count
    likes.reaction_dislike.count
  end
end
