class SearchesController < ApplicationController
  before_action :authenticate_user!

  def event
    @value = params['search']['value']
    if @value != ''
      @events = Event.search_for(@value) # models/event.rb参照
      @events = Kaminari.paginate_array(@events).page(params[:page]).per(10)
      @user = current_user # ユーザー情報表示用（サイドバー）
    else
      @calender_events = Event.all # カレンダー表示用
      @events = Event.all.page(params[:page]).reverse_order.per(10)
      @user = current_user # ユーザー情報表示用（サイドバー）
      @genres = Genre.all # ジャンル一覧表示用
      @tags = Tag.all # タグ一覧表示用
      flash[:error] = '検索ワードを入力してください。'
      render 'events/index'
    end
  end

  def group
    @value = params['search']['value']
    if @value != ''
      @groups = Group.search_for(@value) # models/group.rb参照
      @groups = Kaminari.paginate_array(@groups).page(params[:page]).per(10)
      @user = current_user # ユーザー情報表示用（サイドバー）
    else
      @groups = Group.all.page(params[:page]).reverse_order.per(10)
      @user = current_user # ユーザー情報表示用（サイドバー）
      flash[:error] = '検索ワードを入力してください。'
      render 'groups/index'
    end
  end

  def user
    @value = params['search']['value']
    if @value != ''
      @users = User.search_for(@value) # models/user.rb参照
      @users = Kaminari.paginate_array(@users).page(params[:page]).per(10)
      @user = current_user # ユーザー情報表示用（サイドバー）
    else
      @users = current_user.followings
      @users = Kaminari.paginate_array(@users).page(params[:page]).per(10)
      @user = current_user
      flash[:error] = '検索ワードを入力してください。'
      render 'relationships/followings'
    end
  end
end
