class User < ApplicationRecord
  # devise用
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # バリデーション
  validates :name, length: { minimum: 1 }

  # アソシエーション
  # フォロー機能用：Relationship参照
  has_many :relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followings, through: :relationships, source: :followed # フォローしている場合→follower_idをフォローしている人
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower # フォローされている場合→followed_idをフォローしている人
  # DM機能用
  has_many :entries
  has_many :chats
  has_many :rooms, through: :user_rooms
  # イベント機能用
  has_many :event_users
  has_many :events, through: :event_users, dependent: :destroy
  # イベントコメント用
  has_many :event_comments, dependent: :destroy
  # イベントブックマーク用
  has_many :bookmarks, dependent: :destroy
  # グループ機能用
  has_many :group_users
  has_many :groups, through: :group_users
  # グループ承認機能用
  has_many :applies, dependent: :destroy
  has_many :groups, through: :applies
  # グループコメント機能用
  has_many :group_comments, dependent: :destroy
  # イベント通知機能用
  has_many :active_event_notifications, class_name: 'EventNotice', foreign_key: 'visiter_id', dependent: :destroy
  has_many :passive_event_notifications, class_name: 'EventNotice', foreign_key: 'visited_id', dependent: :destroy
  # グループ通知機能用
  has_many :active_group_notifications, class_name: 'GroupNotice', foreign_key: 'visiter_id', dependent: :destroy
  has_many :passive_group_notifications, class_name: 'GroupNotice', foreign_key: 'visited_id', dependent: :destroy

  # ユーザー画像用（refile）
  attachment :user_image

  # ユーザーが退会していない場合はtrue、退会している場合はfalseを返す。ログイン機能で退会済みユーザーを除外するため使用
  def active_for_authentication?
    super && (is_valid == true)
  end

  # フォローする時
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  # フォローを外す時
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  # フォローしているか確認する場合
  def following?(user)
    followings.include?(user)
  end

  # 検索機能用
  def self.search_for(value)
    @users = []
    @users = User.where(['name LIKE(?) OR introduction LIKE(?)', "%#{value}%", "%#{value}%"])
    @users.uniq
  end

  # SNS認証用
  def self.find_or_create_for_oauth(auth)
    find_or_create_by!(email: auth.info.email) do |user|
      user.provider = auth.provider,
                      user.uid = auth.uid,
                      user.name = auth.info.name,
                      user.email = auth.info.email,
                      user.password = Devise.friendly_token[0, 20]
    end
  end

  # 通知機能用（フォローと同時に通知(EventNotice)を作成する）
  def create_notification_follow!(current_user)
    temp = EventNotice.where(['visiter_id = ? and visited_id = ? and action = ? ', current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_event_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  # 通知機能用（イベント参加と同時に通知(EventNotice)を作成する）
  def create_notification_join!(current_user, event_id)
    temp = EventNotice.where(['visiter_id = ? and visited_id = ? and action = ? ', current_user.id, id, 'join'])
    if temp.blank?
      notification = current_user.active_group_notifications.new(
        visited_id: id,
        event_id: event_id,
        action: 'join'
      )
      notification.save if notification.valid?
    end
  end

  # 通知機能用（グループ参加申請と同時に通知(EventNotice)を作成する）
  def create_notification_join!(current_user, group_id)
    temp = GroupNotice.where(['visiter_id = ? and visited_id = ? and action = ? ', current_user.id, id, 'join'])
    if temp.blank?
      notification = current_user.active_group_notifications.new(
        visited_id: id,
        group_id: group_id,
        action: 'apply'
      )
      notification.save if notification.valid?
    end
  end

  # 通知機能用（グループ参加承認と同時に通知(EventNotice)を作成する）
  def create_notification_approval!(current_user, group_id)
    temp = GroupNotice.where(['visiter_id = ? and visited_id = ? and action = ? ', current_user.id, id, 'approval'])
    if temp.blank?
      notification = current_user.active_group_notifications.new(
        visited_id: id,
        group_id: group_id,
        action: 'approval'
      )
      notification.save if notification.valid?
    end
  end

  # 通知機能用（チャット送信と同時に通知(EventNotice)を作成する）
  def create_notification_chat!(current_user, user_id)
    temp = EventNotice.where(['visiter_id = ? and visited_id = ? and action = ? ', current_user.id, user_id, 'chat'])
    if temp.blank?
      notification = current_user.active_event_notifications.new(
        visited_id: user_id.pop, # user_idにはチャット相手のidが格納されているが、配列になってしまっているため、.popで取り出し
        action: 'chat'
      )
      notification.save if notification.valid?
    end
  end
end
