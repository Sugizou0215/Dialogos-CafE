class EventsController < ApplicationController
  def new
    @genres = Genre.all #ジャンル表示用
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to events_path, notice: 'イベント作成に成功しました'
    else
      render :new
    end
  end

  def show
  end

  def index
    @events = Event.all
  end

  def edit
  end

  def update
  end

  private

    def event_params
      params.require(:event).permit(:name, :introduction, :genre_id, :start_at, :finish_at, :deadline, :tool, :event_image, :capacity, :group_id)
    end

end
