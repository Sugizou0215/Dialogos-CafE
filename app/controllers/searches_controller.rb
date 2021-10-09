class SearchesController < ApplicationController
  def event
    @value = params['search']['value']
    if @value != ""
      @events = Event.search_for(@value) #イベントモデル内のメソッド呼び出し
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
    @groups = Group.search_for(@value) #イベントモデル内のメソッド呼び出し
    @user = current_user #ユーザー情報表示用（サイドバー）
  end
end
