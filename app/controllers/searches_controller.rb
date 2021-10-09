class SearchesController < ApplicationController
  def event
    @value = params['search']['value']
    @events = Event.search_for(@value) #イベントモデル内のメソッド呼び出し
    @user = current_user #ユーザー情報表示用（サイドバー）
  end

  def group
    @value = params['search']['value']
    @groups = Group.search_for(@value) #イベントモデル内のメソッド呼び出し
    @user = current_user #ユーザー情報表示用（サイドバー）
  end
end
