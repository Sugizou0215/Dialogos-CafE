module EventsHelper
  # イベントの開催日時と終了日時を結合
  def event_time(event)
    "#{event.start_at.strftime('%Y/%m/%d %H:%M')} ~ #{event.finish_at.strftime('%Y/%m/%d %H:%M')}"
  end
end
