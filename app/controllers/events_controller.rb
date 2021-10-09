class EventsController < ApplicationController

  before_action :authenticate_user!, except: [:index]
  before_action :ensure_admin_user, only: [:edit, :update] #主催者以外はedit,updateできなくする

  def new
    @genres = Genre.all #ジャンル表示用
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.admin_user_id = current_user.id
    @event.users << current_user
    tag_list = params[:event][:tag_name].split(nil) #タグ機能用
    if @event.save
      @event.save_tag(tag_list) 
      redirect_to events_path, notice: 'イベント作成に成功しました'
    else
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    @admin_user = User.find(@event.admin_user_id)
    @event_comment = EventComment.new
    @event_tags = @event.tags #タグ機能用
  end

  def index
    @events = Event.all
    @user = current_user #ユーザー情報表示用（サイドバー）
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    if @event = Event.update(event_params)
      redirect_to event_path(@event), notice: "正常にイベント情報が変更されました。"
    else
      render "edit"
    end
  end

  #イベントの開催を中止または中止から再開する処理
  def cancel
    @event = Event.find(params[:id])
    #イベントが開催中の場合
    if @event.is_valid == true
      @event.update(is_valid: false)
      flash[:notice] = 'イベントを中止しました。イベント詳細ページから再開も可能です。'
    #イベントが中止中の場合
    else
      @event.update(is_valid: true)
      flash[:notice] = 'イベントを再開しました。'
    end
      @admin_user = User.find(@event.admin_user_id)
      redirect_to event_path(@event)
  end

  #イベントに参加する際の処理
  def join
    @event = Event.find(params[:event_id])
    @event.users << current_user
    redirect_to event_path(@event)
  end

  #イベント参加を中止する際の処理
  def leave
    @event = Event.find(params[:event_id])
    @event.users.delete(current_user)
    redirect_to event_path(@event)
  end

  private

    def event_params
      params.require(:event).permit(:name, :introduction, :genre_id, :start_at, :finish_at, :deadline, :tool, :event_image, :capacity, :group_id)
    end

    def ensure_admin_user
      @event = Event.find(params[:id])
      unless @event.admin_user_id == current_user.id
        redirect_to event_path(@event)
      end
    end

end