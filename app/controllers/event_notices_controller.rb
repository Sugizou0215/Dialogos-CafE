class EventNoticesController < ApplicationController
  def index
    #current_userの投稿に紐づいた通知一覧
    @event_notices = current_user.passive_notifications
    #@event_noticesの中でまだ確認していない(indexに一度も遷移していない)通知のみ
    @event_notices.where(is_checked: false).each do |notice|
      notice.update_attributes(is_checked: true)
    end
  end

  #通知を全削除
  def destroy_all
    @event_notices = current_user.passive_notifications.destroy_all
    redirect_to user_event_notices_path
  end
end
