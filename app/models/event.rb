class Event < ApplicationRecord
  has_many :event_users
  has_many :users, through: :event_users ,dependent: :destroy
  belongs_to :genre
  has_many :event_comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

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

  #検索機能用
  def self.search_for(value)
    @events = Array.new
    @events = Event.where('name LIKE ?', '%' + value + '%')
    # @events << Event.where('introduction LIKE ?', '%' + value + '%')
    return @events.uniq
  end
end

