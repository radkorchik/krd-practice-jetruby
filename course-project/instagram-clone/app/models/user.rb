class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :active_follows,
           class_name: "Follow",
           foreign_key: :follower_id,
           inverse_of: :follower,
           dependent: :destroy
  has_many :passive_follows,
           class_name: "Follow",
           foreign_key: :followed_id,
           inverse_of: :followed,
           dependent: :destroy
  has_many :following, through: :active_follows, source: :followed
  has_many :followers, through: :passive_follows, source: :follower

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  def follows?(other_user)
    following.exists?(other_user.id)
  end
end
