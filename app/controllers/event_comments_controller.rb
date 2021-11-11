class EventCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    event_comment = current_user.event_comments.new(event_comment_params)
    event_comment.event_id = @event.id
    comment_event = event_comment.event
    if event_comment.save
      # 通知の作成
      comment_event.create_notification_comment!(current_user, event_comment)
    end
    @event_comment = EventComment.new
  end

  def destroy
    @event = Event.find(params[:event_id])
    @event_comment = @event.event_comments.find(params[:id])
    @event_comment.destroy
  end

  private

  def event_comment_params
    params.require(:event_comment).permit(:comment)
  end
end
