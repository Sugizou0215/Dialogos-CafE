class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :ensure_admin_user, only: %i[edit update] # 主催者以外はedit,updateできなくする

  def new
    @genres = Genre.all # ジャンル表示用
    @usergroups = GroupUser.where(user_id: current_user.id).pluck(:group_id) # ユーザーの所属するグループ表示するため、検索して@groupsへ
    @groups = Group.where(id: @usergroups)
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.admin_user_id = current_user.id
    @event.users << current_user
    tag_list = params[:event][:tag_name].split(nil) # タグ機能用
    if @event.save
      @event.save_tag(tag_list)
      redirect_to event_path(@event), notice: 'イベント作成に成功しました'
    else
      render :new
    end
  end

  def show
    @event = Event.find(params[:id])
    @admin_user = User.find(@event.admin_user_id)
    @event_comment = EventComment.new
    @event_tags = @event.tags # タグ機能用：現在選択されているイベントに紐づいているタグを入手
    @event_group = Group.find_by(id: @event.group_id) # グループイベント表示用：現在選択されているイベントに紐づいているグループを入手
    @group_users = GroupUser.where(user_id: current_user.id).pluck(:group_id) # ユーザーの所属するグループ表示するため、検索して@user_groupsへ
    @user_groups = Group.where(id: @group_users)
  end

  def index
    @calender_events = Event.all # カレンダー表示用
    @events = Event.all.page(params[:page]).reverse_order.per(10)
    @user = current_user # ユーザー情報表示用（サイドバー）
    @genres = Genre.all # ジャンル一覧表示用
    @tags = Tag.all # タグ一覧表示用
  end

  def edit
    @event = Event.find(params[:id])
    @usergroups = GroupUser.where(user_id: current_user.id).pluck(:group_id) # ユーザーの所属するグループ表示するため、検索して@groupsへ
    @groups = Group.where(id: @usergroups)
    @tags = @event.tags.pluck(:name) # イベントに紐づいたタグの名前のみ抽出
    @event_tags = @tags.join(' ') # 抽出したタグ名を半角スペースで結合
  end

  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      tag_list = params[:event][:tag_name].split(' ') # 入力されたタグを受け取る
      update_tags(tag_list, @event) # コントローラー下部参照
      redirect_to event_path(@event), notice: '正常にイベント情報が変更されました。'
    else
      render 'edit'
    end
  end

  # イベントの開催を中止または中止から再開する処理
  def cancel
    @event = Event.find(params[:id])
    # イベントが開催中の場合
    if @event.is_valid == true
      if @event.update(is_valid: false)
        flash[:notice] = 'イベントを中止しました。イベント詳細ページから再開も可能です。'
      else
        render 'show'
      end
    # イベントが中止中の場合
    else
      @event.update(is_valid: true)
      flash[:notice] = 'イベントを再開しました。'
    end
    @admin_user = User.find(@event.admin_user_id)
    redirect_to event_path(@event)
  end

  # イベントに参加する際の処理
  def join
    @event = Event.find(params[:event_id])
    @event.users << current_user
    @user = User.find(@event.admin_user_id)
    @user.create_notification_join!(current_user, params[:event_id]) # models/user.rb参照：イベント参加と同時に通知作成
    redirect_to event_path(@event)
  end

  # イベント参加を中止する際の処理
  def leave
    @event = Event.find(params[:event_id])
    @event.users.delete(current_user)
    redirect_to event_path(@event)
  end

  private

  def event_params
    params.require(:event).permit(:name, :introduction, :genre_id, :start_at, :finish_at, :deadline, :tool,
                                  :event_image, :capacity, :group_id)
  end

  def ensure_admin_user
    @event = Event.find(params[:id])
    redirect_to event_path(@event) unless @event.admin_user_id == current_user.id
  end

  # タグの更新処理
  def update_tags(tag_list, event)
    @old_tagmaps = Tagmap.where(event_id: event.id) # 編集しようとしているイベントに紐づいていた中間テーブルを@old_tagmapsに入れる
    # この時点で一旦中間テーブルのデータを削除
    @old_tagmaps.each do |map|
      map.delete
    end
    # tagの更新
    tag_list.each do |tag_name|
      @tag = Tag.find_or_create_by(name: tag_name) # タグを入力された内容で探し、あればそのまま、なければ新規作成
      @tag.save
      # 再度1個づつ中間テーブルへ登録
      new_tagmap = Tagmap.new(event_id: @event.id, tag_id: @tag.id)
      new_tagmap.save
    end
  end
end
