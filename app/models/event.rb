class Event < ApplicationRecord
  has_many :event_users
  has_many :users, through: :event_users ,dependent: :destroy
  #ジャンル機能用
  belongs_to :genre
  #コメント機能用
  has_many :event_comments, dependent: :destroy
  #ブックマーク機能用
  has_many :bookmarks, dependent: :destroy
  #タグ機能用
  has_many :tagmaps, dependent: :destroy
  has_many :tags, through: :tagmaps
  #グループとの紐づけ用
  belongs_to :group, optional: true
  #通知機能用
  has_many :event_notices, dependent: :destroy

  #イベント画像用（refile）
  attachment :event_image

  #simple_calender用のメソッド。start_timeが呼び出されると、start_atで設定した時刻が返る
  def start_time
    self.start_at
  end

  #ブックマーク確認用
  def bookmark_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  #検索機能用：検索ワードでname,introductionカラムから検索
  def self.search_for(value)
    @events = Array.new
    @events = Event.where(['name LIKE(?) OR introduction LIKE(?)', "%#{value}%", "%#{value}%"])
    return @events.uniq
  end

  #タグ機能用：検索ワードでname,introductionカラムから検索
  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil? #events/createで保存した@eventに紐付いているタグが存在する場合、タグを配列で全て取得
    old_tags = current_tags - sent_tags #現在取得した@eventに存在するタグから、送信されてきたタグを除いたタグをold_tagsとする
    new_tags = sent_tags - current_tags #送信されてきたタグから、現在存在するタグを除いたタグをnew_tagsとする

    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    new_tags.each do |new|
      new_tag = Tag.find_or_create_by(name: new)
      self.tags << new_tag
    end
  end

  #通知機能(イベントコメント)用
  def create_notification_comment!(current_user, event_comment)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    event = event_comment.event
    temp_ids = EventComment.select(:user_id).where(event_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, event_comment_id, temp_id['user_id'])
      # 同時に、イベント管理者に通知を送る
      if temp_id['user_id'] != event.admin_user_id
        save_notification_comment!(current_user, event_comment.id, user_id)
      end
    end
  end

  def save_notification_comment!(current_user, event_comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_event_notifications.new(
      event_id: id,
      event_comment_id: event_comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visiter_id == notification.visited_id
      notification.is_checked = true
    end
    notification.save if notification.valid?
  end
end

