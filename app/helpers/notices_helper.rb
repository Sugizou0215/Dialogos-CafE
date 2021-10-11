module NoticesHelper

  #通知が発生しているか判定
  def unchecked_notifications
    @notifications = Array.new
    @notifications = current_user.passive_event_notifications.where(is_checked: false) #イベント側の通知があれば@notificationsに格納
    @notifications = @notifications + current_user.passive_group_notifications.where(is_checked: false) #グループ側の通知があれば@notificationsに追加
  end

end
