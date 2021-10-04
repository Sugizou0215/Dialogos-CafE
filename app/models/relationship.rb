class Relationship < ApplicationRecord
  #アソシエーション
  belongs_to :follower, class_name: "User" #フォロー
  belongs_to :followed, class_name: "User" #フォロワー
end
