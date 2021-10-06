class Event < ApplicationRecord
  has_many :event_users
  has_many :users, through: :event_users
  belongs_to :genre

  #イベント画像用（refile）
  attachment :event_image

  #simple_calender用のメソッド。start_timeが呼び出されると、start_atで設定して
  def start_time
    self.start_at 
  end
end

