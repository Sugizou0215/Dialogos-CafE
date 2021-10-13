class SearchesController < ApplicationController
  def event
    @value = params['search']['value']
    if @value != ""
      @events = Event.search_for(@value) #models/event.rb参照
      @events = Kaminari.paginate_array(@events).page(params[:page]).per(10)
      @user = current_user #ユーザー情報表示用（サイドバー）
    else
      @events = Event.all
      @user = current_user #ユーザー情報表示用（サイドバー）
      flash[:error] = '検索ワードを入力してください。'
      render 'events/index'
    end
  end

  def group
    @value = params['search']['value']
    @groups = Group.search_for(@value) #models/group.rb参照
    @groups = Kaminari.paginate_array(@groups).page(params[:page]).per(10)
    @user = current_user #ユーザー情報表示用（サイドバー）
  end

  def user
    @value = params['search']['value']
    @users = User.search_for(@value) #models/user.rb参照
    @users = Kaminari.paginate_array(@users).page(params[:page]).per(10)
    @user = current_user #ユーザー情報表示用（サイドバー）
  end
end
