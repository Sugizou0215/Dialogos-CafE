class Group < ApplicationRecord

  #バリデーション
  validates :name, length: { minimum: 1, maximum: 50 }, uniqueness: true
  validates :introduction, presence: true

  #アソシエーション
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
  #通知機能用
  has_many :group_notices, dependent: :destroy

  #イベント画像用（refile）
  attachment :group_image

  #検索機能用
  def self.search_for(value)
    @groups = Array.new
    @groups = Group.where(['name LIKE(?) OR introduction LIKE(?)', "%#{value}%", "%#{value}%"])
    return @groups.uniq
  end

  #通知機能(グループコメント)用
  def create_notification_comment!(current_user, group_comment)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    group = group_comment.group
    temp_ids = GroupComment.select(:user_id).where(group_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, group_comment.id, temp_id['user_id'])
      # 同時にグループ管理者に通知を送る
      if temp_id['user_id'] != group.admin_user_id
        save_notification_comment!(current_user, group_comment.id, group.admin_user_id)
      end
    end

  end

  def save_notification_comment!(current_user, group_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_group_notifications.new(
      group_id: id,
      group_comment_id: group_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.is_checked = true
    end
    notification.save if notification.valid?
  end

  #通知機能(グループニュース)用
  def create_notification_news!(users, group)
    users.each do |user|
      #users（グループ所属のユーザー）に通知を送る
      notification = user.active_group_notifications.new(
        visiter_id: group.admin_user_id,
        visited_id: user.id,
        group_id: group.id,
        action: 'news'
      )
      notification.save if notification.valid?
    end
  end
end
