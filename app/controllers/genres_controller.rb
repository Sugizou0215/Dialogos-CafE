class GenresController < ApplicationController
  def show
    @genre = Genre.find(params[:id])
    @events = Event.where(genre_id: params[:id]).page(params[:page]).reverse_order.per(10)
    @user = current_user # ユーザー情報表示用（サイドバー）
  end
end
