class BookmarksController < ApplicationController
  def create
    event = Event.find(params[:event_id])
    bookmark = current_user.bookmarks.new(event_id: event.id)
    bookmark.save
    redirect_to event_path(event)
  end

  def destroy
    event = Event.find(params[:event_id])
    bookmark = current_user.bookmarks.find_by(event_id: event.id)
    bookmark.destroy
    redirect_to event_path(event)
  end
end
