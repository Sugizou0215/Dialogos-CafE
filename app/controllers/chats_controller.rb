class ChatsController < ApplicationController

  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    current_user_entries = current_user.entries.pluck(:room_id)
    user_entries = Entry.find_by(user_id: @user.id, room_id: current_user_entries) #チャットの履歴を検索
    #過去にチャットの履歴がある場合：過去のRoomを取り出す
    unless user_entries.nil?
      @room = user_entries.room
    #過去にチャットの履歴がない場合：Roomを現在のユーザーとチャット相手分の２つを新規に生成
    else
      @room = Room.new
      @room.save
      Entry.create(user_id: current_user.id, room_id: @room.id)
      Entry.create(user_id: @user.id, room_id: @room.id)
    end
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    @chat.save
    @user = User.find(@chat.user_id)
    current_user_entries = current_user.entries.pluck(:room_id)
    user_entries = Entry.find_by(user_id: @user.id, room_id: current_user_entries) #チャットの履歴を検索
    @room = user_entries.room
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
    @user_against = @chats.where.not(user_id: @user.id).pluck(:user_id).uniq #チャット相手のidを探して@user_againstに格納（通知用）
    @user.create_notification_chat!(current_user, @user_against) #models/user.rb参照：チャット送信と同時に通知作成
    render 'show'
  end

  private

    def chat_params
      params.require(:chat).permit(:message, :room_id)
    end
end
