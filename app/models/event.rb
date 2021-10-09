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
end

