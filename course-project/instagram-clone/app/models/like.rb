class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum :reaction, { dislike: -1, like: 1 }, prefix: true

  validates :user_id, uniqueness: { scope: :post_id }
  validates :reaction, presence: true
end
