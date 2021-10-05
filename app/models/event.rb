class Event < ApplicationRecord
  belongs_to :genre

  #イベント画像用（refile）
  attachment :event_image

  #以下を
  def start_time
    self.start_at ##Where 'start' is a attribute of type 'Date' accessible through MyModel's relationship
  end
end

