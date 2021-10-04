class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーション
  validates :name, length: { minimum: 1 }

  #アソシエーション
  #フォロー機能用：Relationship参照
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed # フォローしている場合→follower_idをフォローしている人
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower  # フォローされている場合→followed_idをフォローしている人

  #ユーザー画像用（refile）
  attachment :user_image

  #ユーザーが退会していない場合はtrue、退会している場合はfalseを返す。ログイン機能で退会済みユーザーを除外するため使用
  def active_for_authentication?
    super && (self.is_valid == true)
  end

  #フォローする時
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  #フォローを外す時
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  #フォローしているか確認する場合
  def following?(user)
    followings.include?(user)
  end
end
