class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users

  #イベント画像用（refile）
  attachment :group_image
end
