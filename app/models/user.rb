class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーション
  validates :name, length: { minimum: 1 }

  #ユーザー画像用（refile）
  attachment :user_image

  #ユーザーが退会していない場合はtrue、退会している場合はfalseを返す。ログイン機能で退会済みユーザーを除外するため使用
  def active_for_authentication?
    super && (self.is_valid == true)
  end
end
