class TagsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def show
    @tag = Tag.find(params[:id])  # クリックしたタグを取得
    @events = @tag.events.all.page(params[:page]).reverse_order.per(10) # クリックしたタグに紐付けられた投稿を全て表示
    @user = current_user # ユーザー情報表示用（サイドバー）
  end
end
