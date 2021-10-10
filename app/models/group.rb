class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  #参加申請機能用
  has_many :applies, dependent: :destroy
  #新着情報機能用
  belongs_to :group_new, optional: true
  #コメント機能用
  has_many :group_comments, dependent: :destroy
  #イベントとの紐づけ用
  has_many :events

  #イベント画像用（refile）
  attachment :group_image

  #検索機能用
  def self.search_for(value)
    @groups = Array.new
    @groups = Group.where(['name LIKE(?) OR introduction LIKE(?)', "%#{value}%", "%#{value}%"])
    return @groups.uniq
  end
end
