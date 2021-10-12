class BookmarksController < ApplicationController

  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    @bookmark = current_user.bookmarks.new(event_id: @event.id)
    @bookmark.save
  end

  def destroy
    @event = Event.find(params[:event_id])
    @bookmark = current_user.bookmarks.find_by(event_id: @event.id)
    @bookmark.destroy
  end
end
