class ChatsController < ApplicationController
  def show
    @user = User.find(params[:id])
    current_user_entries = current_user.entries.pluck(:room_id)
    user_entries = Entry.find_by(user_id: @user.id, room_id: current_user_entries) #チャットの履歴を検索

    #過去にチャットの履歴がある場合
    unless user_entries.nil?
      @room = user_entries.room
    #過去にチャットの履歴がない場合
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
  end

  private

    def chat_params
      params.require(:chat).permit(:message, :room_id)
    end
end
