class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  has_many :applies, dependent: :destroy
  belongs_to :group_new
  has_many :group_comments, dependent: :destroy

  #イベント画像用（refile）
  attachment :group_image
end
