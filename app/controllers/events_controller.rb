class EventsController < ApplicationController
  def new
    @genres = Genre.all #ジャンル表示用
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.admin_user_id = current_user.id
    if @event.save
      redirect_to events_path, notice: 'イベント作成に成功しました'
    else
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def index
    @events = Event.all
    @user = current_user #ユーザー情報表示用（サイドバー）
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
