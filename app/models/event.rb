class Event < ApplicationRecord
  belongs_to :genre

  #イベント画像用（refile）
  attachment :event_image
end

