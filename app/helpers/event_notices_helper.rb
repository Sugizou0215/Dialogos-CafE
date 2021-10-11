module EventNoticesHelper
  def unchecked_notifications
    @notifications = Array.new
    @notifications = current_user.passive_event_notifications.where(is_checked: false)
    @notifications = @notifications + current_user.passive_group_notifications.where(is_checked: false)
  end
end
